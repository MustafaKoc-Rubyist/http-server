module HTTPServer
  class EchoHandler
    def handle(request)
      message = request.path.delete_prefix("/echo/")
      
      if request.accepts_gzip?
        Response.ok(message, "text/plain", "gzip")
      else
        Response.ok(message)
      end
    end
  end
end