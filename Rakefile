require "json"
require "parallel"
require "yaml"

# How many runs should we do in parallel?
PARALLEL_RUNS = 5

# Path to BrowserStackLocal app
BROWSER_STACK_LOCAL_APP_PATH = "vendor/downloads/BrowserStackLocal"

# How many seconds to wait for the BrowserStack local app to
BROWSER_STACK_LOCAL_APP_WAIT = 5

namespace :browserstack do

  desc "list browsers for browserstack"
  task :browsers do
    YAML.load_file("config/browsers.json").each_with_index do |browser, i|
      puts "#{i + 1}: #{browser.values.join(" ")} - #{browser.to_json}"
    end
  end

  desc "run features via browserstack"
  task :run do
    begin
      unless ENV["BROWSERSTACK_USERNAME"] && ENV["BROWSERSTACK_PASSWORD"]
        puts "The BROWSERSTACK_USERNAME and BROWSERSTACK_PASSWORD environment variables must be set prior to running this task."
        exit
      end
      start_browserstack_local_app
      run_parallel_jobs
    rescue Exception => e
      print "Error occurred: #{e}"
    end
  end

  def start_browserstack_local_app
    app = fork do
      exec(BROWSER_STACK_LOCAL_APP_PATH, ENV["BROWSERSTACK_PASSWORD"], "srv,12121,0,auth,45454,0,rota,34343,0", "-skipCheck", "-force")
    end

    Process.detach(app)
    puts "Waiting for Browserstack local app to connect..."
    sleep(BROWSER_STACK_LOCAL_APP_WAIT)
    puts "Done"
  end

  def run_parallel_jobs
    browsers = YAML.load_file("config/browsers.json")
    total_jobs = browsers.count

    results = Parallel.map(browsers, in_processes: PARALLEL_RUNS) do |browser|
      browser.reject! { |_, v| v.nil? }

      json_config = browser.to_json
      puts "Running Browserstack test: (BROWSERSTACK_BROWSER='#{json_config})'"

      # We're in a subprocess here - set the environment variable
      # BROWSERSTACK_BROWSER to the desired browser configuration for this
      # specific test.
      ENV["BROWSERSTACK_BROWSER"] = json_config
      cmd = "bundle exec rspec"
      puts cmd + " (ENV: #{ENV["BROWSERSTACK_BROWSER"]})\n"

      system(cmd)
    end
    result_count = results.count { |e| !e }

    if result_count == 0
      puts "OK - #{total_jobs} successful"
    else
      puts "#{result_count} failures occurred across #{total_jobs} browsers"
    end
  end
end
