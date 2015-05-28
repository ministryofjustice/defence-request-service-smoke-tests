class FailedSession
   include Singleton

   attr_accessor :error_count, :session_id

   def initialize
     @error_count = 0
   end

   def mark
     if error_count > 0
       puts "Marking session id #{session_id} as failed..."
       status = { status: "error", reason: "#{error_count} tests failed" }
       HTTParty.put(url, body: status, basic_auth: { username: username, password: password })
     end
   end

   private

   def username
     ENV.fetch("BROWSERSTACK_USERNAME")
   end

   def password
     ENV.fetch("BROWSERSTACK_PASSWORD")
   end

   def url
     "https://www.browserstack.com/automate/sessions/#{session_id}.json"
   end
end
