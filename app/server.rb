require "socket"

class HTTPServer
  def initialize(host = "localhost", port = 4221)
    @server = TCPServer.new(host, port)
    puts "Server is running on #{host}:#{port}"
  end

  def start
    loop do
      client_socket = @server.accept
      Thread.new(client_socket) do |client|
        handle_request(client)
      end
    end
  end

  private

  def handle_request(client)
    request_line = client.gets
    _, request_path, _ = request_line.split


    response = {
      body: "",
      status: "404 Not Found"
    }

    # Route handling based on request path
    content_type = "text/plain"
    response = case request_path
              when "/"
                { status: "200 OK", body: "" }
              when /^\/echo\/.+/
                { 
                  status: "200 OK",
                  body: request_path.delete_prefix("/echo/")
                }
              when /^\/files\/.+/
                file_name = request_path.delete_prefix("/files/")
                file_path = "/tmp/#{file_name}"
                content_type, response = generate_file_response(client, file_path)
                response
              when "/user-agent"
                headers = extract_headers(client)
                {
                  status: "200 OK",
                  body: headers["User-Agent"]
                }
              else
                { status: "404 Not Found", body: "" }
              end

    send_response(client, response, content_type)
  end

  def extract_headers(client)
    headers = {}
    while (line = client.gets) && line != "\r\n"
      key, value = line.split(": ", 2)
      headers[key] = value.chomp if key && value
    end
    headers
  end

  def send_response(client, response, content_type = "text/plain")
    http_response = [
      "HTTP/1.1 #{response[:status]}",
      "Content-Type: #{content_type}",
      "Content-Length: #{response[:body].bytesize}",
      "",
      response[:body]
    ].join("\r\n")
    
    client.puts(http_response)
  ensure
    client.close
  end

  def generate_file_response(client, file_path)
    response =if File.exist?(file_path)
      content_type= "application/octet-stream"
      { 
        status: "200 OK",
        body: File.read(file_path)
      }
    else
      content_type= "text/plain"
      { 
        status: "404 Not Found",
        body: ""
      }
    end

    return content_type, response
  end
end

# Start the server if this file is run directly
if __FILE__ == $PROGRAM_NAME
  server = HTTPServer.new
  server.start
end