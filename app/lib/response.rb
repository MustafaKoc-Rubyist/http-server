module HTTPServer
  class Response
    attr_reader :status, :body, :content_type

    def initialize(status:, body: "", content_type: "text/plain")
      @status = status
      @body = body
      @content_type = content_type
    end

    class << self
      def ok(body = "", content_type = "text/plain")
        new(status: "200 OK", body: body, content_type: content_type)
      end

      def created
        new(status: "201 Created")
      end

      def not_found
        new(status: "404 Not Found")
      end

      def method_not_allowed
        new(status: "405 Method Not Allowed")
      end

      def server_error(message = "An error occurred")
        new(status: "500 Internal Server Error", body: message)
      end
    end
  end
end