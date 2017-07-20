class TestingWorker
  include Sidekiq::Worker

  def perform
    SMS.send('14157978944', 'testing')
  end
end
