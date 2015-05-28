require "bundler"
Bundler.require

Dir[Pathname.new(__FILE__).join("../support/**/*.rb")].each { |file| require file }

require "capybara/dsl"
require "capybara/poltergeist"
require "httparty"

print_around_thing = ->(&thing) do
  puts "Waiting for apps to start"
  thr = Thread.new do
    loop do
      sleep 1
      print "."
    end
  end

  thing.call

  thr.kill
  puts ""
  puts "All apps have started"
end

check_apps_have_started = Proc.new do
  print_around_thing.call do
    StatusChecker.check_apps_have_started SERVICE_APP_URI,
      ROTA_APP_URI,
      AUTH_APP_URI
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL

  config.disable_monkey_patching!
  config.order = :defined

  config.before :suite, &check_apps_have_started

  # Keep track of failures and the browser session ID in the FailedSession singleton.
  # We then use them below to report the success or failure of the full suite
  # to BrowserStack
  config.after(:each) do |example|
    if example.exception && Capybara.default_driver == :browserstack
      if session_id = Capybara.current_session.driver.browser.capabilities["webdriver.remote.sessionid"]
        FailedSession.instance.session_id = session_id
        FailedSession.instance.error_count += 1
      end
    end
  end

  # Mark the Browserstack session as failed if any item failed
  config.after :suite do
    # Force the browser to close first. This will mark the session as successful,
    # and we then need to override the session to be marked as failed.
    Capybara.current_session.driver.quit
    FailedSession.instance.mark
  end
end
