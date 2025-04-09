[![progress-banner](https://backend.codecrafters.io/progress/http-server/bccbc57f-62ea-4e32-8768-20b055f7ae88)](https://app.codecrafters.io/users/codecrafters-bot?r=2qF)

# Ruby HTTP Server Implementation

## Overview

This repository contains a custom HTTP/1.1 server implementation written in Ruby as part of the CodeCrafters "Build Your Own HTTP Server" challenge. The server is capable of handling multiple concurrent client connections and implements several HTTP endpoints according to the HTTP/1.1 protocol standards.

## Project Structure

```
.
├── app/                  # Main application code
│   ├── handlers/         # HTTP route handlers
│   │   ├── echo_handler.rb          # Handler for /echo endpoint
│   │   ├── files_handler.rb         # Handler for /files endpoint
│   │   ├── root_handler.rb          # Handler for / (root) endpoint
│   │   └── user_agent_handler.rb    # Handler for /user-agent endpoint
│   ├── lib/              # Core server libraries
│   │   ├── config.rb               # Server configuration
│   │   ├── request.rb              # HTTP request parsing
│   │   ├── request_handler.rb      # Request processing logic
│   │   ├── response.rb             # HTTP response generation
│   │   ├── router.rb               # URL routing system
│   │   └── server.rb               # TCP server implementation
│   └── server.rb         # Main entry point
├── .codecrafters/        # CodeCrafters challenge files
├── .ruby-lsp/            # Ruby language server configuration
├── Gemfile               # Ruby dependencies
├── Gemfile.lock          # Locked Ruby dependencies
├── codecrafters.yml      # CodeCrafters configuration
└── your_program.sh       # Shell script to run the server
```

## Features

This HTTP server implements the following features:

1. **Concurrent Connection Handling**: Uses Ruby threads to handle multiple client connections simultaneously.
2. **HTTP/1.1 Protocol Support**: Properly parses and generates HTTP/1.1 requests and responses.
3. **Multiple Endpoints**:
   - `/` - Returns a 200 OK response
   - `/echo/<message>` - Echoes back the message in the response body
   - `/user-agent` - Returns the User-Agent header from the request
   - `/files/<filename>` - Serves and stores files from a directory specified when starting the server

4. **HTTP Methods**:
   - GET - For retrieving resources
   - POST - For creating/updating resources (used with the /files endpoint)

5. **Error Handling**: Properly handles and responds with appropriate HTTP status codes for various error conditions.

## Implementation Details

### Core Components

1. **Server (app/lib/server.rb)**: 
   - Creates a TCP server using Ruby's Socket library
   - Accepts incoming connections and delegates to request handler
   - Handles each connection in a separate thread for concurrency

2. **Request (app/lib/request.rb)**:
   - Parses HTTP request lines, headers, and body
   - Extracts method, path, headers, and content

3. **Response (app/lib/response.rb)**:
   - Generates HTTP responses with appropriate status codes, headers, and body
   - Handles different response types (OK, Created, Not Found, etc.)

4. **Router (app/lib/router.rb)**:
   - Routes incoming requests to the appropriate handler based on the URL path
   - Manages the mapping between URL patterns and handler classes

5. **Request Handler (app/lib/request_handler.rb)**:
   - Coordinates the overall request processing flow
   - Reads the request, routes it, and sends the response

### Endpoint Handlers

1. **Root Handler (app/handlers/root_handler.rb)**:
   - Handles requests to the root path (/) with a simple 200 OK response

2. **Echo Handler (app/handlers/echo_handler.rb)**:
   - Extracts a message from the URL path and returns it in the response body
   - URL format: /echo/<message>

3. **User-Agent Handler (app/handlers/user_agent_handler.rb)**:
   - Returns the User-Agent header from the client's request

4. **Files Handler (app/handlers/files_handler.rb)**:
   - Handles file operations with GET and POST methods
   - GET: Serves a file from the specified directory
   - POST: Saves a file to the specified directory

## Running the Server

To run the server locally:

1. Ensure you have Ruby 3.3 installed
2. Install dependencies: `bundle install`
3. Run the server: `./your_program.sh`

By default, the server runs on localhost:4221.

To specify a directory for the /files endpoint, you can use the --directory flag:

```sh
./your_program.sh --directory /path/to/files
```

## Development

This project is part of the CodeCrafters "Build Your Own HTTP Server" challenge. To test your implementation against the CodeCrafters test suite:

```sh
git commit -am "Your commit message"
git push origin master
```

## Requirements

- Ruby 3.3
- Bundler for dependency management

**Note**: If you're viewing this repo on GitHub, head over to
[codecrafters.io](https://codecrafters.io) to try the challenge.

# Passing the first stage

The entry point for your HTTP server implementation is in `app/server.rb`. Study
and uncomment the relevant code, and push your changes to pass the first stage:

```sh
git commit -am "pass 1st stage" # any msg
git push origin master
```

Time to move on to the next stage!

# Stage 2 & beyond

Note: This section is for stages 2 and beyond.

1. Ensure you have `ruby (3.3)` installed locally
1. Run `./your_program.sh` to run your program, which is implemented in
   `app/server.rb`.
1. Commit your changes and run `git push origin master` to submit your solution
   to CodeCrafters. Test output will be streamed to your terminal.
