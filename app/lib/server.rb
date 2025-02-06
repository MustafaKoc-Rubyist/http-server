require_relative 'request_handler'
require_relative 'response'
require_relative 'config'
require 'socket'

module HTTPServer
  class Server
    def initialize(host = "localhost", port = 4221)
      @server = TCPServer.new(host, port)
      @config = Config.new
      puts "Server is running on #{host}:#{port}"
    end

    def start
      loop do
        client_socket = @server.accept
        Thread.new(client_socket) { |client| handle_connection(client) }
      end
    end

    private

    def handle_connection(client)
      handler = RequestHandler.new(client, @config)
      handler.process
    ensure
      client.close
    end
  end
end