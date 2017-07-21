module SMS
  class InvalidPhoneNumber < StandardError; end

  def self.send(phone_number, message)
    client.publish(phone_number: valid_number(phone_number), message: message)
  end

  def self.client
    sns = Aws::SNS::Client.new()
    sns.set_sms_attributes({
      attributes: {
        "DefaultSMSType" => "Transactional",
        "DefaultSenderID" => "Brian"
      }
    })
    sns
  end

  def self.valid_number(number)
    # We default the country code to '1' in a config/initializer
    # Phoner::Phone.parse(n).to_s returns the number with '+1'
    number = Phoner::Phone.parse(number).to_s
    raise InvalidPhoneNumber if number.empty?
    number
  end
end
