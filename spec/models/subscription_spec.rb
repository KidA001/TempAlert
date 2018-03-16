require 'rails_helper'

describe Subscription, type: :model do

  describe 'validations' do
    let(:subject) { create(:subscription) }

    it { should validate_uniqueness_of(:user).scoped_to(:type) }

    context 'when subscription is ideal_temperature' do
      let(:subject) { build(:subscription, :ideal_temperature, temperature: 100) }

      it 'validates temperature exists' do
        expect(subject).to be_valid
      end

      context 'when metadata is empty' do
        before { subject.metadata = {} }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:metadata]).to(
            include('must contain ideal_temperature key with an integer value')
          )
        end
      end

      context 'when metadata.ideal_temperature is not an integer' do
        before { subject.metadata = { ideal_temperature: 'hot' } }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:metadata]).to(
            include('must contain ideal_temperature key with an integer value')
          )
        end
      end
    end
  end

  describe 'scopes' do
    describe '#ideal_temp' do
      let!(:subscription1) do
        create(:subscription, :ideal_temperature, temperature: 100)
      end

      let!(:subscription2) do
        create(:subscription, :ideal_temperature, temperature: 103)
      end

      let!(:subscription3) do
        create(:subscription, :ideal_temperature, temperature: 105)
      end

      it 'returns ideal_temp subscriptions where the temp is <= provided temp' do
        expect(described_class.ideal_temp(103)).to include(subscription1)
        expect(described_class.ideal_temp(103)).to include(subscription2)
        expect(described_class.ideal_temp(103)).not_to include(subscription3)
      end
    end

    describe '#active' do
      let!(:subscription1) do
        create(:subscription, sms_enabled: true, email_enabled: true)
      end

      let!(:subscription2) do
        create(:subscription, sms_enabled: true, email_enabled: true)
      end

      let!(:subscription3) do
        create(:subscription, sms_enabled: false, email_enabled: false)
      end

      it 'returns subscriptions where email OR sms are true' do
        expect(described_class.active).to include(subscription1)
        expect(described_class.active).to include(subscription2)
        expect(described_class.active).not_to include(subscription3)
      end
    end
  end
end
