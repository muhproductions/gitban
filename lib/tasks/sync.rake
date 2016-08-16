namespace :sync do
  desc 'Sync Gitlab Issues into GitBan'
  task issues: :environment do
    gitlab = Gitlab.new(token: ENV['TOKEN'], api_url: ENV['URL'])
    Gitlab::Sync.new(gitlab: gitlab).sync!
  end
end
