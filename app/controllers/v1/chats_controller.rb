class V1::ChatsController < ApplicationController
    include V1::ErrorResponses::Response
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}

    def create
        application = Application.find(params[:application_token])
        @chat = Chat.new(token: application.token)
        if @chat.save
            render :create, status: :created
        else
            render_error('token is required', 400)
        end
    end

    def show
        @chat = Chat.where(token: params[:application_token], number: params[:number]).includes(:messages).first
        render :show, status: :ok
    end

    private

    def chat_params
        params.require(:chat).permit(:token)
    end
end
