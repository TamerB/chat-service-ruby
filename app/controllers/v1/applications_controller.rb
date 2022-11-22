class V1::ApplicationsController < ApplicationController
    include V1::ErrorResponses::Response
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}

    def create
        @application = Application.new(application_params)
        if @application.save
            render :create, status: :created
        else
            render_error('name is required', 400)
        end
    end

    def show
        @application = Application.where(token: params[:token]).includes(:chats).first
        if @application.nil?
            record_not_found
        else
            render :show, status: :ok
        end
    end

    def update
        @application = Application.find(params[:token])
        if @application.update(application_params)
            @status = 'ok'
            render :create, status: :ok
        else
            render_error('unprocessable entity', 422)
        end
    end

    private

    def application_params
        params.require(:application).permit(:name)
    end
end
