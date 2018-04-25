CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY"],        # required
    :aws_secret_access_key  => ENV["AWS_SECRET_KEY"]         # required
  }

  if Rails.env.production?
    config.fog_directory  = ENV["AWS_BUCKET"]                  # required
  else
    config.fog_directory  = ENV["AWS_BUCKET_DEV"]
  end
end
