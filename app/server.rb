require "socket"
require 'optparse'

class HTTPServer
  def initialize(host = "localhost", port = 4221)
    @server = TCPServer.new(host, port)
    puts "Server is running on #{host}:#{port}"
  end

  def start
    loop do
      client_socket = @server.accept
      Thread.new(client_socket) { |client| handle_request(client) }
    end
  end

  private

  def handle_request(client)
    request_line = client.gets
    method, request_path, version = request_line.split

    headers = extract_headers(client)
    content_type, response = process_request(method, request_path, headers, client)

    if response.nil?
      response = { status: "500 Internal Server Error", body: "An error occurred" }
    end

    send_response(client, response, content_type)
  end

  def process_request(method, request_path, headers, client)
    content_type = "text/plain"
    response = case request_path
    when "/"
      { status: "200 OK", body: "" }
    when /^\/echo\/.+/
      { status: "200 OK", body: request_path.delete_prefix("/echo/") }
    when /^\/files\/.+/
      content_type, response = handle_file_request(method, request_path, headers, client)
      response
    when "/user-agent"
      { status: "200 OK", body: headers["User-Agent"] }
    else
      { status: "404 Not Found", body: "" }
    end
    [content_type, response]
  end

  def handle_file_request(method, request_path, headers, client)
    file_name = extract_file_name(request_path)
    directory = get_output_file_directory
    file_path = "#{directory}#{file_name}"
    content_type = "text/plain"

    if method == "GET"
      content_type, response = generate_file_response(client, file_path)
      response
    elsif method == "POST"
      request_body = read_request_body(headers, client)
      write_to_file(file_path, request_body)
      { status: "201 Created", body: "" }
    else
      { status: "405 Method Not Allowed", body: "" }
    end
    [content_type, response]
  end

  def read_request_body(headers, client)
    content_length = headers["Content-Length"].to_i
    client.read(content_length)
  end

  def write_to_file(file_path, content)
    File.open(file_path, "w") { |file| file.write(content) }
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
    response = if File.exist?(file_path)
      content_type = "application/octet-stream"
      { status: "200 OK", body: File.read(file_path) }
    else
      content_type = "text/plain"
      { status: "404 Not Found", body: "" }
    end
    return content_type, response
  end

  def get_output_file_directory
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: app/server.rb [options]"

      opts.on("--directory DIRECTORY", "Specify the directory where files are stored") do |dir|
        options[:directory] = dir
      end
    end.parse!

    options[:directory] || "tmp"
  end

  def extract_file_name(request_path)
    request_path.delete_prefix("/files/")
  end
end

# Start the server if this file is run directly
if __FILE__ == $PROGRAM_NAME
  server = HTTPServer.new
  server.start
end