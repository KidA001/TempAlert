require 'rails_helper'

describe SMS do
  before { allow(Aws::SNS::Client).to receive(:new) { client } }
  let(:client) { double('aws', publish: nil, set_sms_attributes: nil) }


  describe '#send' do
    let(:phone_number) { '14158675309' }
    let(:message) { 'hello' }

    it 'calls publish on AWS client with correct params' do
      expect(client).to receive(:publish).with(
        phone_number: phone_number,
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
end
