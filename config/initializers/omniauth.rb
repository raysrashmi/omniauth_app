require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  PROVIDER = YAML.load_file("#{RAILS_ROOT}/config/provider.yml")[RAILS_ENV]
  
  provider :twitter, PROVIDER['twitter']['key'], PROVIDER['twitter']['secret']
  provider :facebook,  PROVIDER['facebook']['key'], PROVIDER['facebook']['secret']
  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end