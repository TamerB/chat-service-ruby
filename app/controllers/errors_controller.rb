# ErrorsController hanles requests to undefined routes
class ErrorsController < ApplicationController
  def handle_root_not_found
    render_error('route not found', 400)
  end
end
