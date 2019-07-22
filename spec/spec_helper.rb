require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'rspec/expectations'
require 'selenium-webdriver'
require 'site_prism'
require 'pages/app'
require 'byebug'

RSpec.configure do |config|

  config.include Capybara::RSpecMatchers

  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { 'args' =>  %w[enable-javascript disable-infobars disable-gpu privileged]}
    )
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :desired_capabilities => options)
  end

  Capybara.app_host = 'https://www.google.com'

  Capybara.configure do |config|
    config.default_max_wait_time = 10 # seconds
    config.default_driver = :selenium
    config.javascript_driver = :selenium
  end

  config.before(:all) do
    @app ||= App.new
  end

end
