module SMS

  def self.send(phone_number, message)
    client.publish(phone_number: phone_number, message: message)
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
end
