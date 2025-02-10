module HTTPServer
  class RootHandler
    def handle(request)
      if request.accepts_gzip?
        Response.ok("", "text/plain", "gzip")
      else
        Response.ok
      end
    end
  end
end