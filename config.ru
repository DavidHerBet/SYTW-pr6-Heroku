require './lib/rps'

builder = Rack::Builder.new do
  use Rack::Static, :urls => ["/public"]
  use Rack::ShowExceptions
  use Rack::Lint
  use Rack::Session::Cookie, 
        :key => 'rack.session',
        :secret => 'some_secret'
  run RockPaperScissors::App.new
end
Rack::Server.start(
  :app => builder,
  :Port => 9292,
  :server => 'thin')
