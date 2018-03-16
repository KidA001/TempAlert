require 'rails_helper'

describe User, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:google_id) }
    it { should validate_presence_of(:email) }
  end
end
