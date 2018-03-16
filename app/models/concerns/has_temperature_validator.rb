# frozen_string_literal: true

class HasTemperatureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    temperature = value['ideal_temperature']
    if temperature.nil? || !temperature.kind_of?(Integer)
      record.errors[attribute] << 'must contain ideal_temperature key with an integer value'
    end
  end
end
