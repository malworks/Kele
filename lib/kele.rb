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

  def get_messages(page = nil)
    if page
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token }, body: {"page": page })
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
    end
  end

  # 500 error when entering token, this is what I'm passing in: mal.create_message("malloryworks@gmail.com","523730", "", "", "Another test!")
  def create_message(email, recipient_id, subject, message)
    response = self.class.post("https://www.bloc.io/api/v1/messages",
      body: {
        sender: email,
        recipient_id: recipient_id,
        subject: subject,
        # token: token,
        "stripped-text": message
      },
      headers: { "authorization" => @auth_token },
    )
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions",
      body: {
        assignment_branch: assignment_branch,
        assignment_commit_link: assignment_commit_link,
        checkpoint_id: checkpoint_id,
        comment: comment,
        enrollment_id: enrollment_id
      },
      headers: { "authorization" => @auth_token },
    )
  end
end
