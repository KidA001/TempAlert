require 'rails_helper'
describe Notification::NotificationBase do
  require './spec/support/mock_notif'
  before do
    allow(subject).to receive(:ready_to_send?) { ready_to_send }
    allow(subject).to receive(:key) { key }
    allow(subject).to receive(:notif) { notif_name }
    allow(subject).to receive(:quota) { quota }
    allow(subject).to receive(:sms_body) { sms_body }
    allow(subject).to receive(:email_subject) { email_subject }
    allow(subject).to receive(:email_body) { email_body }
    allow(subject).to receive(:subscribers) { [subscriber] }
  end
  let(:subject) { Notification::MockNotif.new }
  let(:key) { notif_name }
  let(:ready_to_send) { true }
  let(:notif_name) { 'fooooo' }
  let(:email_body) { 'foobarbaz' }
  let(:sms_body) { 'foobar' }
  let(:quota) { 1.hour }
  let(:email_subject) { 'foo' }
  let(:subscriber) { create(:subscriber) }
  let(:sms_subscription) { true }
  let(:email_subscription) { true }

  describe '.send_notif!' do
    before do
      allow(subscriber).to receive(:sms?).with(notif_name).and_return(sms_subscription)
      allow(subscriber).to receive(:email?).with(notif_name).and_return(email_subscription)
    end

    context 'when ready_to_send? returns false' do
      let(:ready_to_send) { false }
      
      it 'does not send a notif' do
        expect(SMS).not_to receive(:send)
        expect(Email).not_to receive(:send)
        subject.send_notif!
      end
    end

    context 'with sms and email enabled' do
      it 'sends email and sms' do
        expect(SMS).to receive(:send).with(subscriber.phone, sms_body)
        expect(Email).to receive(:send).with(
          subscriber.email, email_subject, email_body
        )
        subject.send_notif!
      end
    end

    context 'when the subscriber has sms disabled' do
      let(:sms_subscription) { false }
      
      it 'does not send sms' do
        expect(SMS).not_to receive(:send)
        subject.send_notif!
      end
    end

    context 'when the subscriber has email disabled' do
      let(:email_subscription) { false }
      
      it 'does not send email' do
        expect(Email).not_to receive(:send)
        subject.send_notif!
      end
    end

    describe 'quota' do
      it 'sets an expiring key in redis' do
        expect($redis).to receive(:setex).with(key, quota.to_s.to_i, nil)
        subject.send_notif!
      end
    end
  end
end
