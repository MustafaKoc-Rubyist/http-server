require_relative 'response'
require_relative 'router'
require_relative 'request'

module HTTPServer
  class RequestHandler
    def initialize(client, config)
      @client = client
      @config = config
      @router = Router.new(config)
    end

    def process
      request = Request.new(@client)
      response = @router.route(request)
      send_response(response)
    end

    private

    def send_response(response)
      status_line = "HTTP/1.1 #{response.status}"
      headers = response.headers.map { |key, value| "#{key}: #{value}" }
      
      http_response = [
        status_line,
        *headers,
        "",
        response.body
      ].join("\r\n")

      @client.puts(http_response)
    end
  end
end