require 'rails_helper'

describe Notification::IdealTemp do
  let(:subject) { described_class.new(temp) }
  let(:user) { subscription.user }
  let!(:subscription) do
    create(
      :subscription,
      :ideal_temperature,
      sms_enabled: sms,
      email_enabled: email,
      temperature: temp
    )
  end

  describe 'send_notif!' do
    let(:key) { subject.send(:key, user) }
    let(:email) { true }
    let(:sms) { true }

    before { allow(SMS).to receive(:send) }
    before { allow(Email).to receive(:send) }

    context 'with a matching ideal temperature' do
      let(:temp) { 105 }

      it 'sends a sms and email' do
        expect(SMS).to receive(:send).with(user.phone, subject.send(:sms_body))
        expect(Email).to receive(:send).with(
          user.email,
          subject.send(:email_subject),
          subject.send(:email_body)
        )
        subject.send_notif!
      end

      it 'sets the notif quota for the user' do
        subject.send_notif!
        expect($redis.exists(key)).to eq(true)
      end

      context 'when email is not enabled' do
        let(:email) { false }

        it 'does not send an email' do
          expect(Email).not_to receive(:send)
          expect(SMS).to receive(:send)
          subject.send_notif!
        end
      end

      context 'when sms is not enabled' do
        let(:sms) { false }

        it 'does not send an email' do
          expect(SMS).not_to receive(:send)
          expect(Email).to receive(:send)
          subject.send_notif!
        end
      end

      context 'when the notif quota has been exceeded' do
        it 'does not send a notif' do
          subject.send_notif!

          expect(SMS).not_to receive(:send)
          expect(Email).not_to receive(:send)
          subject.send_notif!
        end
      end
    end

    context 'when the temperature does not match' do
      let(:temp) { 100 }
      let(:subject) { described_class.new(temp - 1) }

      it 'does not send any notifs' do
        expect(SMS).not_to receive(:send)
        expect(Email).not_to receive(:send)
        subject.send_notif!
      end
    end
  end
end
