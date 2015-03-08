class DashboardWorker
  include Sidekiq::Worker
    
  def perform(widget_id, data_id, data_value)
    HTTParty.post(BreezeBot::Application.config.dashboard_url + "/#{widget_id}",
      :body => { "auth_token" => "YOUR_AUTH_TOKEN", "#{data_id}" => "#{data_value}" }.to_json)
  end
  
end