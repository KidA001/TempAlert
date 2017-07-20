require 'rails_helper'

describe Subscriber, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:google_id) }
    it { should validate_presence_of(:email) }
  end

  describe '#sms?' do
    let(:notif) { 'ideal_temp' }
    let(:subscriber) { create(:subscriber, :ideal_temp_subscription) }

    context 'when they are subscribed to sms' do
      it 'returns true' do
        expect(subscriber.sms?(notif)).to eq(true)
      end
    end

    context 'when they are not subscribed to sms' do
      it 'returns false' do
        subscriber.update_subscription!([name: notif, sms: false, email: true])
        expect(subscriber.sms?(notif)).to eq(false)
      end
    end

    context 'when a subscription does not exist' do
      let(:notif) { 'fooooo' }
      
      it 'returns false' do
        expect(subscriber.email?(notif)).to eq(false)
      end
    end
  end

  describe '#email?' do
    let(:notif) { 'ideal_temp' }
    let(:subscriber) { create(:subscriber, :ideal_temp_subscription) }

    context 'when they are subscribed to email' do
      it 'returns true' do
        expect(subscriber.email?(notif)).to eq(true)
      end
    end

    context 'when they are not subscribed to email' do
      it 'returns false' do
        subscriber.update_subscription!([name: notif, email: false, sms: true])
        expect(subscriber.email?(notif)).to eq(false)
      end
    end

    context 'when a subscription does not exist' do
      let(:notif) { 'fooooo' }
      
      it 'returns false' do
        expect(subscriber.email?(notif)).to eq(false)
      end
    end
  end

  describe '.update_subscription!' do
    let(:subscriber) { create(:subscriber) }

    context 'when the subscription does not exists' do
      it 'adds the subscription' do
        subscriber.update_subscription!([name: 'foo', email: false, sms: true])
        expect(subscriber.subscriptions['foo']).to eq(
          { "sms" => true, "email" => false }
        )
      end
    end

    context 'when the subscription exists' do
      let(:subscriber) { create(:subscriber, :ideal_temp_subscription) }

      it 'updates the subscription' do
        subscriber.update_subscription!(
          [name: 'ideal_temp', email: false, sms: false]
        )
        expect(subscriber.subscriptions['ideal_temp']).to eq(
          { "sms" => false, "email" => false }
        )
      end
    end
  end

  describe '#subscribed_to' do

  end
end
