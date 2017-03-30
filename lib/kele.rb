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
  def create_message(email, recipient_id, subject, token, message)
    response = self.class.post("https://www.bloc.io/api/v1/messages",
      body: {
        sender: email,
        recipient_id: recipient_id,
        subject: subject,
        token: token,
        "stripped-text": message
      },
      headers: { "authorization" => @auth_token },
    )
  end

  def create_message(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions
",
      body: {
        assignment_branch: "checkpoint-7",
        assignment_commit_link: "https://github.com/malworks/Kele/commit/35c7a8b547c4a07412b3d88eb64c8219391bcacd",
        checkpoint_id: "2162",
        comment: "This is a comment",
        enrollment_id: ""
      },
      headers: { "authorization" => @auth_token },
    )
  end
end
