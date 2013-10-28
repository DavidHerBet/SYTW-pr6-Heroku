# encoding: UTF-8
require "test/unit"
require "rack/test"
require "./lib/rps"

class RPSAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use(Rack::Session::Cookie, {:key => 'rack.session',
                                  :domain => 'example.com',
                                  :secret => 'some_secret'})
      run RockPaperScissors::App.new
    end.to_app
  end

  def test_index
    get "/"
    assert last_response.ok?
  end

  # Comprueba que la raíz no contenga una tabla con el resultado de la tirada
  def test_index_body
    get "/"
    assert !(last_response.body.include? ("<table></table>"))
  end

  def test_title
    get "/"
    assert last_response.body.include? ("<title>RPS with Haml, CSS, Sessions and Testing</title>")
  end

  def test_styles
    get "/public/css/estilos.css"
    assert last_response.ok?
  end

  def test_paper
    get "/?choice=paper"
    assert last_response.ok?
  end

  def test_paper_body
    get "/?choice=paper"
    assert correct_answer(last_response.body)
  end

  # Comprueba que la respuesta sea una de las indicadas
  def correct_answer(answer)
    return true if (/You win the match/ =~ answer)
    return true if (/You loose, computer wins/ =~ answer)
    return true if (/There is a tie/ =~ answer)
  end

  def test_rock
    get "/?choice=rock"
    assert last_response.ok?
  end

  def test_rock_body
    get "/?choice=rock"
    assert correct_answer(last_response.body)
  end

  def test_scissors_choice
    get "/?choice=scissors"
    assert last_response.ok?
  end

  def test_scissors_body
    get "/?choice=scissors"
    assert correct_answer(last_response.body)
  end
end
