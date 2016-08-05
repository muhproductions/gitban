
Ethon.logger = Logger.new(nil)

class Gitlab 

  attr_accessor :token, :api_url

  def initialize token: nil, api_url: nil
    @token, @api_url = token, api_url
  end

  def groups
    @groups ||= api('groups') 
  end

  def projects
    @projects ||= api("projects/all")
  end

  def issues 
    @issues ||= groups.flat_map do |group|
      api "groups/#{group['id']}/issues" 
    end.compact
  end

  def merge_requests 
    @mr ||= projects.flat_map do |project|
      api "projects/#{project['id']}/merge_requests"
    end.compact
  end

  def flush
    @mr, @issues, @projects, @groups = []
  end

  def api path
    api_return = []
    hydra = Typhoeus::Hydra.new
    r = Typhoeus::Request.new(
      "#{api_url}/#{path}", 
      params: { private_token: token }
    )
    api_return << load_json(r.run)
    requests = []
    (r.response.headers["X-Total-Pages"].to_i - 1).times do |i|
      re = Typhoeus::Request.new("#{api_url}/#{path}", 
                                 params: { 
                                   private_token: token,
                                   page: i + 2 
                                 })
      requests << re
      hydra.queue re
    end
    hydra.run
    api_return << requests.map{ |r| load_json(r.response) }.compact
    api_return.flatten
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
        project = if p = gitlab.projects.find{ |x| x['id'] == issue['id'] }
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
                               link: p['web_url'])
  end

  def gitlab_internal_id(issue)
    if issue.has_key?('source_project_id') and 
      issue.has_key?('target_project_id') and
      issue.has_key?('merge_status')
      "!#{issue['iid']}"
    else
      "##{issue['iid']}"
    end
  end

  def task!(issue: nil, ms: nil, as: nil, project: nil)
    x = Task.find_or_create_by!(title: issue['title'])
    x.update!(milestone_id: ms.try(:id), 
              assignee_id: as.try(:id),
              gitlab_id: issue['id'],
              gitlab_internal_id: gitlab_internal_id(issue),
              project_id: project.try(:id),
              state: issue['state'],
              labels: issue['labels'],
              due_date: issue['due_date'])
    x
  end

  def logger
    Rails.logger
  end


end
