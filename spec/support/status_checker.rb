module StatusChecker
  MAX_TIMEOUT = 60

  class << self

    def check_apps_have_started *app_uris
      if !apps_have_started *app_uris
        abort "Not all the applications had started after #{MAX_TIMEOUT} seconds"
      end
    end

    private

    def apps_have_started *app_uris
      app_uris.all? { |uri_string|
        uri = URI uri_string
        has_app_started? uri.hostname, uri.port
      }
    end

    def has_app_started?(hostname, port)
      begin
        Timeout::timeout(MAX_TIMEOUT) do
          loop do
            begin
              s = TCPSocket.new(hostname, port)
              s.close
              return true
            rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            end
          end
        end
      rescue Timeout::Error
      end

      return false
    end
  end
end
