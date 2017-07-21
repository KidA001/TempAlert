require 'rails_helper'

describe SMS do
  before { allow(Aws::SNS::Client).to receive(:new) { client } }
  let(:client) { double('aws', publish: nil, set_sms_attributes: nil) }


  describe '#send' do
    let(:phone_number) { build(:subscriber).phone }
    let(:message) { 'hello' }

    it 'calls publish on AWS client with correct params' do
      expect(client).to receive(:publish).with(
        phone_number: '+1'+phone_number,
        message: message
      )
      described_class.send(phone_number, message)
    end
  end

  describe '#client' do
    it 'returns a AWS Client' do
      expect(described_class.client).to eq(client)
    end

    it 'sets the sms attributes' do
      expect(client).to receive(:set_sms_attributes).with(
        { attributes: {
            "DefaultSMSType" => "Transactional",
            "DefaultSenderID" => "Brian"
        }}
      )
      described_class.client
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
