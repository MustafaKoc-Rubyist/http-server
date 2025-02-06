module HTTPServer
  class FilesHandler
    def initialize(directory)
      @directory = directory
    end

    def handle(request)
      file_name = request.path.delete_prefix("/files/")
      file_path = File.join(@directory, file_name)

      case request.method
      when "GET"
        handle_get(file_path)
      when "POST"
        handle_post(file_path, request.body)
      else
        Response.method_not_allowed
      end
    end

    private

    def handle_get(file_path)
      if File.exist?(file_path)
        Response.ok(File.read(file_path), "application/octet-stream")
      else
        Response.not_found
      end
    end

    def handle_post(file_path, content)
      File.write(file_path, content)
      Response.created
    rescue => e
      Response.server_error(e.message)
    end
  end
end