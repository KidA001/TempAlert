require 'rails_helper'

describe SMS do
  before { allow(Twilio::REST::Client).to receive(:new) { client_double } }
  let(:client_double) { double }
  let(:msg_client) { double }

  describe '#send' do
    before do
      allow(client_double).to receive_message_chain("api.account.messages") { msg_client }
    end
    let(:phone_number) { build(:subscriber).phone }
    let(:message) { 'hello' }

    it 'calls publish on AWS client with correct params' do
      expect(msg_client).to receive(:create).with(
        from: described_class::FROM,
        to: '+1'+phone_number,
        body: message
      )
      described_class.send(phone_number, message)
    end
  end

  describe '#client' do
    it 'returns a AWS Client' do
      expect(described_class.client).to eq(client_double)
    end
  end

  describe '#valid_number' do
    it 'returns the number with the country prefix' do
      expect(described_class.valid_number('5556661122')).to eq('+15556661122')
    end

    it 'raises when the number is invalid' do
      expect {
        described_class.valid_number('555666112211111')
      }.to raise_error(SMS::InvalidPhoneNumber)
    end
  end
end
