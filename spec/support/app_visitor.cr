require "http/client"

class AppVisitor
  CSRF_TOKEN = "statictesttoken"

  getter! response
  @response : HTTP::Client::Response? = nil

  def visit(path : String, headers : HTTP::Headers? = nil)
    request = HTTP::Request.new("GET", path, headers)
    @response = process_request(request)
  end

  def put(path : String, body : Hash(String, String), headers_hash : Hash(String, String)? = nil)
    headers = headers_hash ? hash_to_headers(headers_hash) : nil
    request_with_body("PUT", path, with_csrf_token(body), headers)
  end

  def post(path : String, body : Hash(String, String), headers_hash : Hash(String, String)? = nil)
    headers = headers_hash ? hash_to_headers(headers_hash) : nil
    request_with_body("POST", path, with_csrf_token(body), headers)
  end

  def response_body
    body = @response.not_nil!.body
    if body[0,5] == "ERROR"
      raise Exception.new(body)
    elsif body == ""
      JSON.parse("{}")
    else
      JSON.parse(body)
    end
  end

  private def with_csrf_token(body : Hash(String, String))
    body[Lucky::ProtectFromForgery::PARAM_KEY] = CSRF_TOKEN
    body
  end

  private def request_with_body(method : String, path : String, body : Hash(String, String), headers : HTTP::Headers? = nil)
    body_strings = [] of String
    body.each do |key, value|
      body_strings << "#{URI.escape(key)}=#{URI.escape(value)}"
    end
    request = HTTP::Request.new(method, path, headers, body_strings.join("&"))
    @response = process_request(request)
  end

  private def process_request(request)
    io = IO::Memory.new
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)
    context.session[Lucky::ProtectFromForgery::SESSION_KEY] = CSRF_TOKEN
    middlewares.call context
    response.close
    io.rewind
    HTTP::Client::Response.from_io(io, decompress: false)
  end

  def middlewares
    HTTP::Server.build_middleware([
      Lucky::HttpMethodOverrideHandler.new,
      Lucky::LogHandler.new,
      Lucky::SessionHandler.new,
      Lucky::Flash::Handler.new,
      Lucky::ErrorHandler.new(action: Errors::Show),
      Lucky::RouteHandler.new,
      Lucky::StaticFileHandler.new("./public", false),
      Lucky::RouteNotFoundHandler.new
    ])
  end

  private def hash_to_headers(hash : Hash(String, String))
    headers = HTTP::Headers.new
    hash.keys.map { |key| headers.add key, hash[key]}
    headers
  end

  module Matchers
    def redirect_to(path : String)
      RedirectToExpectation.new(path)
    end
  end

  struct RedirectToExpectation
    def initialize(@expected_path : String)
    end

    def match(visitor : AppVisitor)
      visitor.response.status_code == 302 &&
        visitor.response.headers.fetch("Location") == @expected_path
    end

    def failure_message(visitor : AppVisitor)
      if visitor.response.headers.["Location"]?
        "Expected to redirect to \"#{@expected_path}\", but redirected to #{visitor.response.headers.fetch("Location")}"
      else
        "Expected to redirect to \"#{@expected_path}\", but did not redirected at all"
      end
    end
  end

  def includes?(expected_value)
    response.body.includes? expected_value
  end
end
