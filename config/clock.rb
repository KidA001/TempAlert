require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  every 2.minutes, '2 minute.jobs' do
    IdealTempWorker.perform_async
  end

  every 30.minutes, '30 minute.jobs' do
    LeftOnWorker.perform_async
  end
end
