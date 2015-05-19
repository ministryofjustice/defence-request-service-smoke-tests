require "bundler"
Bundler.require

Dir[Pathname.new(__FILE__).join("../support/**/*.rb")].each { |file| require file }

require "capybara/dsl"
require "capybara/poltergeist"

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
end


