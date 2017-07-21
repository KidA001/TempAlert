module SMS
  class InvalidPhoneNumber < StandardError; end
  FROM = '+15103691553'

  def self.send(phone_number, message)
    client.api.account.messages.create(
      from: FROM,
      to: valid_number(phone_number),
      body: message
    )
  end

  def self.client
    Twilio::REST::Client.new
  end

  def self.valid_number(number)
    # We default the country code to '1' in config/initializer/phone.rb
    # Phoner::Phone.parse(n).to_s returns the number with '+1'
    number = Phoner::Phone.parse(number).to_s
    raise InvalidPhoneNumber if number.empty?
    number
  end
end
