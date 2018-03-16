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
end
