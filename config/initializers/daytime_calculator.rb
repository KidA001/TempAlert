module DayCalculator
  refine ActiveSupport::TimeWithZone do

    def daytime? &block
      hour = self.hour
      hour >= 6 && hour <= 20
    end
  end
end
