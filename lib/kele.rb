require 'httpary'

class Kele
  include HTTParty

  def initialize(username, password)
    @username = username
    @password = password

    base_uri 'https://www.bloc.io/api/v1'
    self.class.post('https://www.bloc.io/api/v1/sessions', @username, @password)
  end
end
