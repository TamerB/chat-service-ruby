class ErrorsController < ApplicationController
    def handle_root_not_found
        render json: { message: "route not found", status: 404}, status: 404
     end
end
