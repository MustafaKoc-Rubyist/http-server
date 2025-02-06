module HTTPServer
  class RootHandler
    def handle(request)
      Response.ok
    end
  end
end