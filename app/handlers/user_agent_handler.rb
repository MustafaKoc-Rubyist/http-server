module HTTPServer
  class UserAgentHandler
    def handle(request)
      Response.ok(request.headers["User-Agent"])
    end
  end
end