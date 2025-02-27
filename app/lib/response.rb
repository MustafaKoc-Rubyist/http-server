module HTTPServer
  class Response
    attr_reader :status, :body, :headers

    def initialize(status:, body: "", content_type: "text/plain", content_encoding: nil)
      @status = status
      @body = body
      @headers = {
        "Content-Type" => content_type,
        "Content-Length" => body.bytesize.to_s
      }
      @headers["Content-Encoding"] = content_encoding if content_encoding
    end

    class << self
      def ok(body = "", content_type = "text/plain", content_encoding = nil)
        new(status: "200 OK", body: body, content_type: content_type, content_encoding: content_encoding)
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