require_relative '../require_app'
require_app

require 'figaro'
require 'shoryuken'
require_relative './../app/domain/clustering/runner/k_means_main'

# Shoryuken worker class to clone repos in parallel
class ClusterWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config() = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLUSTER_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request) 
    city = JSON.parse(request)["city"]
    CafeMap::CityCluster.new(city).cluster
  rescue StandardError
    puts 'Cluster EXISTS -- ignoring request'
  end
end