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
      http_response = [
        "HTTP/1.1 #{response.status}",
        "Content-Type: #{response.content_type}",
        "Content-Length: #{response.body.bytesize}",
        "",
        response.body
      ].join("\r\n")

      @client.puts(http_response)
    end
  end
end