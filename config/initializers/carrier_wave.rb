CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                        # required
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],                        # required
      :region                 => 'ap-northeast-1'                  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']                     # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end