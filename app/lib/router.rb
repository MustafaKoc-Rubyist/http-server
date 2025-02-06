require_relative '../handlers/root_handler'
require_relative '../handlers/echo_handler'
require_relative '../handlers/files_handler'
require_relative '../handlers/user_agent_handler'

module HTTPServer
  class Router
    def initialize(config)
      @config = config
    end

    def route(request)
      case request.path
      when "/"
        RootHandler.new.handle(request)
      when /^\/echo\/.+/
        EchoHandler.new.handle(request)
      when /^\/files\/.+/
        FilesHandler.new(@config.directory).handle(request)
      when "/user-agent"
        UserAgentHandler.new.handle(request)
      else
        Response.not_found
      end
    end
  end
end