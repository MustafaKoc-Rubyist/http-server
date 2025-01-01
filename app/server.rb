require "socket"

server = TCPServer.new("localhost", 4221)
puts "Server is running on localhost:4221"

loop do
  client_socket, client_address = server.accept
  

  response = "Hello World!"
  
  headers = [
    "HTTP/1.1 200 OK",
    "Content-Type: text/plain",
    "Content-Length: #{response.bytesize}",
    "",
    response
  ].join("\r\n")
  
  client_socket.puts(headers)
  client_socket.close
end