class ApplicationController < ActionController::API
    include V1::ErrorResponses::Response
    include V1::Cache::RedisCache
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}
end
