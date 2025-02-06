require_relative 'lib/server'

if __FILE__ == $PROGRAM_NAME
  server = HTTPServer::Server.new
  server.start
end