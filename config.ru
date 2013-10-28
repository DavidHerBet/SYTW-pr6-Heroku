require './lib/rps'

builder = Rack::Builder.new do
  use Rack::Static, :urls => ["/public"]
  use Rack::ShowExceptions
  use Rack::Lint
  use Rack::Session::Cookie, 
        :key => 'rack.session',
        :domain => 'example.com',
        :secret => 'some_secret'
  run RockPaperScissors::App.new
end

# Indica en que puerto y con que servidor se ejecuta la aplicación
puts ">> Iniciando servidor Thin"
puts ">> Aplicación RPS"
puts ">> http://www.example.com:9292/"
puts ">> Presione Ctr + C para cancelar"

Rack::Server.start(
  :app => builder,
  :Port => 9292,
  :server => 'thin',
  :Host => 'www.example.com')
