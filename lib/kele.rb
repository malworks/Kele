require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'


  def initialize(email, password)
    @auth = { email: email, password: password }
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: @auth)
    raise "Invalid email or password" if !@auth
  end
end
