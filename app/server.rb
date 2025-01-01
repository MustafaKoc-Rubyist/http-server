require "socket"

server = TCPServer.new("localhost", 4221)
puts "Server is running on localhost:4221"

loop do
  client = server.accept
  _, path, _ = client.gets.split
  
  response = path == "/" ? "Hello World!" : ""
  status = path == "/" ? "200 OK" : "404 Not Found"
  
  client.puts "HTTP/1.1 #{status}\r\nContent-Type: text/plain\r\nContent-Length: #{response.bytesize}\r\n\r\n#{response}"
  client.close
end