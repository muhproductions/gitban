
Ethon.logger = Logger.new(nil)

class Gitlab 

  attr_accessor :token, :api_url

  def initialize token: nil, api_url: nil
    @token, @api_url = token, api_url
  end

  def groups
    @groups ||= begin 
                  r = Typhoeus::Request.new "#{api_url}/groups", 
                    params: { private_token: token }
                  logger.debug "Gitlab - Loading groups ..."
                  load_json r.run
                end
  end

  def projects
    @projects ||= begin 
                   r = Typhoeus::Request.new "#{api_url}/projects/all", 
                     params: { private_token: token }
                   logger.debug "Gitlab - Loading projects ..."
                   load_json r.run
                 end
  end

  def issues 
    @issues ||= begin 
                  groups.flat_map do |group|
                    r = Typhoeus::Request.new "#{api_url}/groups/#{group['id']}/issues", 
                      params: { private_token: token }
                    logger.debug "Gitlab - Loading issues over groups ..."
                    load_json r.run
                  end
                end
  end

  private

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
