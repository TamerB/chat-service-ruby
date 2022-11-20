class V1::ApplicationsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    def create
        @application = Application.new(application_params)
        if @application.save
            render :create, status: :created
        else
            @message = 'name is required'
            @status = 400
            render :error, status: :bad_request
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
            @message = 'unprocessable entity'
            @status = 422
            render :error, status: :unprocessable_entity
        end
    end

    private

    def application_params
        params.require(:application).permit(:name)
    end

    def record_not_found
        @message = 'not found'
        @status = 404
        render :error, status: :not_found
    end
end
