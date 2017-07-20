require 'rails_helper'

describe Record, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:temperature) }
    it { should validate_presence_of(:recorded_at) }
  end

  describe '#current' do
    let!(:record) { create(:record, recorded_at: Time.now) }

    it 'returns the most current record' do
      create(:record, recorded_at: 5.minutes.ago)
      expect(described_class.current).to eq(record)
    end

    context 'when the latest record is over 10min old' do
      let!(:record) { create(:record, recorded_at: 11.minutes.ago) }
      
      it 'returns nil' do
        expect(described_class.current).to be_nil
      end
    end
  end

  describe '#above_temp_since' do
    let(:temp) { 100 }
    let(:hours) { 1 }

    context 'when records meet min sample size and are above temp' do
      let(:min_records) { Record::MIN_RECORDS_PER_HOUR }
      before { min_records.times { create(:record, temperature: temp) } }

      it 'returns true' do
        result = described_class.above_temp_since?(temp, hours)
        expect(result).to eq(true)
      end
    end

    context 'when records do not meet min sample size but are above temp' do
      let(:min_records) { Record::MIN_RECORDS_PER_HOUR - 1 }
      before { min_records.times { create(:record, temperature: temp) } }
      
      it 'returns false' do
        result = described_class.above_temp_since?(temp, hours)
        expect(result).to eq(false)
      end
    end

    context 'it checks sample size per hour' do
      let(:min_records) { Record::MIN_RECORDS_PER_HOUR }
      let(:hours) { 2 }

      context 'when records meet the sample size per hour' do
        before do
          min_records.times do
            create(:record, temperature: temp, recorded_at: 30.minutes.ago)
          end
          min_records.times do
            create(:record, temperature: temp, recorded_at: 75.minutes.ago)
          end
        end

        it 'returns true' do
          result = described_class.above_temp_since?(temp, hours)
          expect(result).to eq(true)
        end
      end

      context 'when records do not meet the sample size per hour' do
        before do
          min_records.times do
            create(:record, temperature: temp, recorded_at: 30.minutes.ago)
          end
          min_records.times do
            create(:record, temperature: temp, recorded_at: 30.minutes.ago)
          end
        end

        it 'returns false' do
          result = described_class.above_temp_since?(temp, hours)
          expect(result).to eq(false)
        end
      end
    end
  end
end
