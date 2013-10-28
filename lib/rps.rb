require 'rack/request'
require 'rack/response'
require 'haml'

module RockPaperScissors
  class App 
 
    def initialize(app = nil)
      @app = app
      @content_type = :html
      @defeat = {:rock => :scissors,
                 :paper => :rock,
                 :scissors => :paper}
      @throws = @defeat.keys
      @results = {:win => "You win the match.",
                  :loose => "You loose, computer wins.",
                  :tie => "There is a tie."}
    end

    # Getters y setters
    attr_reader :results, :defeat
    attr_accessor :computer_throw, :player_throw,
                  :answer, :counter

    # Define el entorno y la variable de acceso a la sesión
    def set_env(env)
      @env = env
      @session = env['rack.session']
    end


    # Setters y getters de las variables (cookies) que 
    # almacenarán el valor de las partidas jugadas, ganadas, 
    # perdidas y empatadas
    def games
      return @session[:games].to_i if @session[:games]
      @session[:games] = 0
    end

    def games=(value)
       @session[:games] = value
    end

    def won 
      return @session[:won].to_i if @session[:won]
      @session[:won] = 0 
    end 

    def won=(value)
       @session[:won] = value
    end

    def lost 
      return @session[:lost].to_i if @session[:lost]
      @session[:lost] = 0 
    end 

    def lost=(value)
       @session[:lost] = value
    end

    def ties 
      return @session[:ties].to_i if @session[:ties]
      @session[:ties] = 0 
    end 

    def ties=(value)
       @session[:ties] = value
    end

    # Reinicia los valores de las cookies de partidas
    def reset
      self.games = 0
      self.won = 0
      self.lost = 0
      self.ties = 0
    end

    def call(env)
      set_env(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new
      
      @computer_throw = @throws.sample
      @player_throw = req.GET["choice"]
      @player_throw = player_throw.to_sym if !player_throw.nil?
      @answer = if !@throws.include?(player_throw)
                  ""
                elsif player_throw == computer_throw
                  self.games = self.games + 1
                  self.ties = self.ties + 1
                  self.results[:tie]
                elsif computer_throw == self.defeat[player_throw]
                  self.games = self.games + 1
                  self.won = self.won + 1
                  self.results[:win]
                else
                  self.games = self.games + 1
                  self.lost = self.lost + 1
                  self.results[:loose]
                end

      if !player_throw.nil? and (:reset == player_throw)
        self.reset
      end
                     
      engine = Haml::Engine.new File.open("views/index.haml").read 
      res.write engine.render({}, 
          :answer => @answer, 
          :choose => @choose,
          :throws => @throws,
          :computer_throw => @computer_throw,
          :player_throw => @player_throw,
          :games => self.games,
          :won => self.won,
          :lost => self.lost,
          :ties => self.ties)
      res.finish
    end # call
  end   # App
end     # RockPaperScissors
