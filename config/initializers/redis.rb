$redis =
  if ENV.include?('REDISTOGO_URL')
    Redis.new(url: ENV['REDISTOGO_URL'])
  else
    Redis.new
  end
