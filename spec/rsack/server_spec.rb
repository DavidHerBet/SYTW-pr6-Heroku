require 'spec_helper'

describe Rsack::Server do

  def server
    Rack::MockRequest.new(Rsack::Server.new(
                            Rack::Session::Cookie.new(
                              RockPaperScissors::App.new,
                                :key => 'rack.session',
                                :domain => 'example.com',
                                :secret => 'some_secret')))
  end

  context '/' do
    it "Debería retornar un código 200" do
      response = server.get('/')
      response.status.should == 200
    end

    it "No debería de tener ningún resultado asociado a una tirada" do
      response = server.get('/')
      response.body.include?('Result').should_not be_true
    end

    it "Debería tener un contador de partidas" do
      response = server.get('/?choice=reset')
      response.body.include?('Games played').should be_true
    end

    it "Debería generar una cookie de sesión" do
      response = server.get('/')
      response.header['Set-Cookie'].include?('rack.session').should be_true
    end

    it "El dominio debería ser example.com" do
      response = server.get('/')
      response.header['Set-Cookie'].include?('domain=example.com').should be_true
    end
  end

  context '/?choice=rock' do
    it "Debería retornar un código 200" do
      response = server.get('/?choice=rock')
      response.status.should == 200
    end

    it "Debería mostrar la elección escogida" do
      response = server.get('/?choice=rock')
      response.body.include?('Your choice').should be_true
    end

    it "Debería mostrar el resultado de la jugada" do
      response = server.get('/?choice=rock')
      response.body.include?('Result').should be_true
    end
  end

  context '/?choice=paper' do
    it "Debería retornar un código 200" do
      response = server.get('/?choice=paper')
      response.status.should == 200
    end
  
    it "Debería mostrar la elección escogida" do
      response = server.get('/?choice=paper')
      response.body.include?('Your choice').should be_true
    end

    it "Debería mostrar el resultado de la jugada" do
      response = server.get('/?choice=paper')
      response.body.include?('Result').should be_true
    end
  end

  context '/?choice=scissors' do
    it "Debería retornar un código 200" do
      response = server.get('/?choice=scissors')
      response.status.should == 200
    end
  
    it "Debería mostrar la elección escogida" do
      response = server.get('/?choice=scissors')
      response.body.include?('Your choice').should be_true
    end

    it "Debería mostrar el resultado de la jugada" do
      response = server.get('/?choice=scissors')
      response.body.include?('Result').should be_true
    end
  end

  context '/?choice=reset' do
    it "Debería retornar un código 200" do
      response = server.get('/?choice=reset')
      response.status.should == 200
    end

    it "El contador de partidas debería estar a cero" do
      response = server.get('/?choice=reset')
      response.body.include?('Games played: 0').should be_true
    end
  end

end
