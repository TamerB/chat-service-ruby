class ApplicationController < ActionController::API
  include V1::ErrorResponses::Response
  include V1::Cache::RedisCache
  include V1::Validators
  rescue_from ActiveRecord::RecordNotFound, with: -> { render_error('not found', 404) }
  rescue_from Bunny::ConnectionClosedError, with: -> { render_internal_error('RabbitMQ service is unreachable') }
end
