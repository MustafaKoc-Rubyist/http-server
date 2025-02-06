module HTTPServer
  class EchoHandler
    def handle(request)
      message = request.path.delete_prefix("/echo/")
      Response.ok(message)
    end
  end
end