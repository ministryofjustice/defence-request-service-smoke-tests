require "selenium/webdriver"

Capybara.app_host = "http://localhost:12121"
Capybara.run_server = false

if ENV["BROWSERSTACK_BROWSER"]
  username = ENV.fetch("BROWSERSTACK_USERNAME")
  password = ENV.fetch("BROWSERSTACK_PASSWORD")

  capabilities = JSON.parse(ENV.fetch("BROWSERSTACK_BROWSER"))
  capabilities["project"] = "Defence Request Service Smoke Tests"
  capabilities["build"] = ENV.fetch("BUILD_NUMBER", "Build #{Time.now.to_i}")
  capabilities["acceptSslCerts"] = true

  capabilities["browserstack.debug"] = true
  capabilities['browserstack.local'] = true

  Capybara.register_driver :browserstack do |app|
    Capybara::Selenium::Driver.new(app, browser: :remote, url: "https://#{username}:#{password}@hub.browserstack.com/wd/hub", desired_capabilities: capabilities)
  end
  Capybara.default_driver = :browserstack

else

  LOG_DIR = File.expand_path("../../", File.dirname(__FILE__)) + "/log"

  Capybara.configure do |config|
    config.javascript_driver = :poltergeist
    config.default_driver = :poltergeist

    config.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        phantomjs_logger: File.open("#{LOG_DIR}/test_phantomjs.log", "a"),
      })
    end
  end
end