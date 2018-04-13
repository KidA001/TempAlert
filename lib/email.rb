# frozen_string_literal: true

module Email
  EMAIL_FROM = 'no-reply@somahouse.family'

  def self.send(to, subject, body)
    request = build_request(to, subject, body)
    SENDGRID.client.mail._("send").post(request_body: request)
  end

  def self.build_request(to, subject, body)
    {
      personalizations: [{
        to: [{ email: to }],
        subject: subject
      }],
      from: { email: EMAIL_FROM },
      content: [{
        type: "text/plain",
        value: body
      }]
    }
  end
end
