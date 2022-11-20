class V1::ChatsController < ApplicationController
    before_action :set_chat, only: [:show, :update]
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    def create
        application = Application.find(params[:application_token])
        @chat = Chat.new(token: application.token)
        if @chat.save
            render :create, status: :created
        else
            @message = 'token is required'
            @status = 400
            render :error, status: :bad_request
        end
    end

    def show
        render :show, status: :ok
    end

    private

    def chat_params
        params.require(:chat).permit(:token)
    end

    def set_chat
        @chat = Chat.where(token: params[:application_token], number: params[:number]).first
    end

    def record_not_found
        @message = 'not found'
        @status = 404
        render :error, status: :not_found
    end
end
