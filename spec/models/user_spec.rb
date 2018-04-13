# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  let(:subject) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:google_id) }
    it { should validate_presence_of(:email) }
  end

  describe '.subscription_for' do
    context 'when a subscription exists' do
      let!(:subscription) { create(:subscription, type: :extended_use, user: subject) }

      it 'returns the subscription' do
        expect(subject.subscription_for(:extended_use)).to eq(subscription)
      end
    end

    context 'when a subscription does not exists' do
      it 'returns an initialized subscription' do
        result = subject.subscription_for(:extended_use)
        expect(result.user).to eq(subject)
        expect(result).to be_extended_use
        expect(result.id).to be_nil
      end
    end
  end
end
