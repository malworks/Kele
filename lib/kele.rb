require 'httparty'
require 'json'
require 'pry'

class Kele
  include HTTParty
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

  def get_roadmap(roadmap_id)
    response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{roadmap_id}")
    puts JSON.parse(response)
  end
end
