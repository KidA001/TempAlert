# frozen_string_literal: true

module Notice
  def self.error(e)
    NewRelic::Agent.notice_error(e)
  end

  def self.event(event, kwargs)
    NewRelic::Agent.record_custom_event(event.to_s, **kwargs.symbolize_keys)
  end
end
