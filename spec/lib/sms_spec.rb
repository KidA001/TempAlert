require 'rails_helper'

describe SMS do
  before do
    allow(TWILIO).to(
      receive_message_chain(:api, :account, :messages).and_return(client)
    )
  end
  let(:client) { double }

  describe '#send' do
    let(:phone_number) { build(:user).phone }
    let(:message) { 'hello' }

    it 'calls publish on Twilio client with correct params' do
      expect(client).to receive(:create).with(
        from: described_class::FROM,
        to: '+1'+phone_number,
        body: message
      )
      described_class.send(phone_number, message)
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
