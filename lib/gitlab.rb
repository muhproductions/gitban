
Ethon.logger = Logger.new(nil)

class Gitlab

  attr_accessor :token, :api_url

  def initialize token: nil, api_url: nil
    @token, @api_url = token, api_url
  end

  def update_gitlab_issue(task)
    id = task.gitlab_id
    project_id = task.project.gitlab_id

    labels = if task.in_progress?
               (task.labels.to_a + ['in-progress']) unless task.labels.to_a.include?('in-progress')
             else
               task.labels.to_a - ['in-progress']
             end.to_a

    if task.done?
      event = 'close'
    else
      event = 'reopen'
    end

    task.update labels: labels

    put("projects/#{project_id}/issues/#{id}",
         params: { state_event: event, labels: labels.join(',') })

  end

  def groups
    @groups ||= get('groups').compact
  end

  def projects
    @projects ||= get("projects/all").compact
  end

  def issues
    @issues ||= begin
      @issues = groups.flat_map do |group|
        get "groups/#{group['id']}/issues"
      end.compact
      @issues += groups.flat_map do |group|
        get "groups/#{group['id']}/issues", params: { state: :closed }
      end.compact
    end
  end

  def merge_requests
    @mr ||= projects.flat_map do |project|
      get "projects/#{project['id']}/merge_requests"
    end.compact
  end

  def flush
    @mr, @issues, @projects, @groups = []
  end

  def get path, params: {}
    api_return = []
    hydra = Typhoeus::Hydra.new
    r = Typhoeus::Request.new(
      "#{api_url}/#{path}",
      params: params.merge({ private_token: token })
    )
    api_return << load_json(r.run)
    requests = []
    (r.response.headers["X-Total-Pages"].to_i - 1).times do |i|
      re = Typhoeus::Request.new("#{api_url}/#{path}",
                                 params: params.merge({
                                   private_token: token,
                                   page: i + 2
                                 }))
      requests << re
      hydra.queue re
    end
    hydra.run
    api_return << requests.map{ |r| load_json(r.response) }.compact
    api_return.flatten
  end

  def put path, params: {}
    api_return = []
    r = Typhoeus::Request.new(
      "#{api_url}/#{path}",
      method: :put,
      params: params.merge({ private_token: token })
    )
    load_json(r.run)
  end

  def load_json r
    if r.code.between? 200, 299
      Oj.load r.body
    else
      logger.error "Gitlab - request failed with code: #{r.code}"
      nil
    end
  end

  def logger
    Rails.logger
  end

end

class Gitlab::Sync

  attr_accessor :gitlab

  def initialize gitlab: nil
    @gitlab = gitlab
    unless gitlab.instance_of? ::Gitlab
      raise TypeError, '"gitlab" should be an instance of ::Gitlab'
    end
  end

  def sync!
    ApplicationRecord.transaction do
      gitlab.flush
      (gitlab.merge_requests + gitlab.issues).map do |issue|
        milestone = if ms = issue["milestone"]
                      milestone!(ms)
                    end
        assignee = if as = issue["assignee"]
                     assignee!(as)
                   end
        project = if p = gitlab.projects.find{ |x| x['id'] == issue['project_id'] }
                    project!(p)
                  end
        task! issue: issue,
          ms: milestone,
          as: assignee,
          project: project
      end
      true
    end
  end

  private

  def milestone!(m)
    x = Milestone.find_or_create_by!(title: m["title"])
    x.update!(due_date: m['due_date'])
    x
  end

  def assignee!(a)
    x = Assignee.find_or_create_by!(name: a["name"])
    x.update!(username: a['username'])
    x
  end

  def project!(p)
    Project.find_or_create_by!(name: p["name"], 
                               namespace: p['namespace']['name'],
                               link: p['web_url'],
                               gitlab_id: p['id'])
  end

  def merge_request?(issue)
    issue.has_key?('source_project_id') and 
      issue.has_key?('target_project_id') and
      issue.has_key?('merge_status')
  end

  def gitlab_internal_id(issue)
    merge_request?(issue) ? "!#{issue['iid']}" : "##{issue['iid']}"
  end

  def task_type(issue)
    merge_request?(issue) ? "merge_request" : "issue"
  end

  def task!(issue: nil, ms: nil, as: nil, project: nil)
    x = Task.find_or_create_by!(gitlab_id: issue['id'], 
                               type: task_type(issue))
    x.update!(milestone_id: ms.try(:id),
              assignee_id: as.try(:id),
              title: issue['title'],
              type: task_type(issue),
              gitlab_internal_id: gitlab_internal_id(issue),
              project_id: project.try(:id),
              state: issue['state'],
              labels: issue['labels'],
              description: issue['description'],
              due_date: issue['due_date'])
    x
    process_filter(x) unless x.column_id
  end

  def process_filter task
    Filter.all.each do |filter|
      regexp = Regexp.new filter.match
      str = case filter.type
              when 'namespace'
                task.project.namespace
              when 'project'
                task.project.name
              when 'title'
                task.title
              end
      task.update! column_id: filter.column.id if str[regexp]
    end
  end

  def logger
    Rails.logger
  end


end
