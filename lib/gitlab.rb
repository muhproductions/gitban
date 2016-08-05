
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
