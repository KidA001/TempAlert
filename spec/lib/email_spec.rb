require 'rails_helper'

describe Email do
  let(:to) { 'foo@bar.net' }
  let(:subject) { 'I love tests' }
  let(:body) { 'I really do' }

  describe '#send' do
    before do
      allow(SENDGRID).to(
        receive_message_chain(:client, :mail, :_).and_return(client)
      )
    end
    let(:client) { double('sg_client', post: nil) }
    let(:request) { described_class.build_request(to, subject, body) }

    it 'calls the client with correct arguments' do
      expect(client).to receive(:post).with(request_body: request)
      described_class.send(to, subject, body)
    end
  end

  describe '#build_request' do
    it 'builds a sendgred request' do
      result = described_class.build_request(to, subject, body)
      expect(result).to eq(
        { 
          personalizations: [{ to: [{ email: to }], subject: subject }],
          from: { email: Email::EMAIL_FROM },
          content: [{ type: 'text/plain', value: body }]
        }
      )
    end
  end
end
