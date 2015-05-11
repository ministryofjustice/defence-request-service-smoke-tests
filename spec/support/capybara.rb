Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.default_driver = :poltergeist

  config.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {
      phantomjs_logger: File.open("#{Rails.root}/log/test_phantomjs.log", "a"),
    })
  end

  config.run_server = false
end
