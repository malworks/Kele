require 'httparty'
require 'json'
require 'pry'
require '/Users/ohohraptor/bloc/code/kele/lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @creds = { email: email, password: password }
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: @creds)

    @auth_token = response["auth_token"]

    raise "Invalid email or password" if !@auth_token
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token })
  end

  def get_mentor_availability(id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{id}/student_availability")
  end

  def get_messages(page)
    response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token }, body: {"page": page })

  end
end
