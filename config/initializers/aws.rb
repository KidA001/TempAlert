Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(
    SECRET[:aws_access_key_id], SECRET[:aws_secret_key]
  )
})
