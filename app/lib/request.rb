module HTTPServer
  class Request
    attr_reader :method, :path, :headers, :body

    def initialize(client)
      @client = client
      parse_request_line
      @headers = parse_headers
      @body = read_body if content_length > 0
    end

    def accepts_gzip?
      encoding = headers["Accept-Encoding"]
      encoding && encoding.include?("gzip")
    end

    private

    def parse_request_line
      request_line = @client.gets
      @method, @path, @version = request_line.split
    end

    def parse_headers
      headers = {}
      while (line = @client.gets) && line != "\r\n"
        key, value = line.split(": ", 2)
        headers[key] = value.chomp if key && value
      end
      headers
    end

    def content_length
      (@headers["Content-Length"] || "0").to_i
    end

    def read_body
      @client.read(content_length)
    end
  end
end

