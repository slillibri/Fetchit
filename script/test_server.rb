#!/usr/bin/env ruby
require 'eventmachine'
require 'evma_httpserver'

class Handler < EventMachine::Connection
  include EventMachine::HttpServer
  
  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new(self)

    case @http_request_uri      
    when "/ok"
      resp.status = '200'
      resp.content = File.read('ok_response.html')
    when "/redirect"
      resp.status = '301'
      resp.headers['location'] = 'http://127.0.0.1:8080/ok'
    when "/redirect_perm"
      resp.status = '301'
      resp.headers['location'] = 'http://127.0.0.1:8080/redirect_perm'
    when "/redirect_temp"
      resp.status = '302'
      resp.headers['location'] = 'http://127.0.0.1:8080/redirect_temp'
    when "/error"
      resp.status = '500'
      resp.content = 'error'
    else
      resp.status = '400'
      resp.content = 'default, your test is incorrect'
    end
  
    resp.send_response
  end
end

EventMachine::run {
  EventMachine::start_server("127.0.0.1", 8080, Handler)
  puts "Listening..."
}
