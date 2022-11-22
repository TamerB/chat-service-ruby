class V1::MessagesController < ApplicationController
    include V1::ErrorResponses::Response
    before_action :set_message, only: [:show, :update]
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}

    def create
        chat = Chat.where(token: params[:application_token], number: params[:chat_number]).first
        if chat.nil?
            render_error('not found', 404)
        elsif params[:body].nil?
            render_error('body is required', 400)
        else
            @message = Message.new(token: chat.token, chat_number: chat.number, body: params[:body])
            if @message.save
                render :create, status: :created
            else
                render_error('missing required values', 400)
            end
        end
    end

    def update
        if params[:body].nil?
            render_error('body is required', 400)
        else
            if @message.update(message_params)
                @status = 'ok'
                render :create, status: :ok
            else
                render_error('unprocessable entity', 422)
            end
        end
    end

    def index
        @messages = Message.where(token: params[:application_token], chat_number: params[:chat_number]).order('created_at')
        render :index, status: :ok
    end

    def show
        if @message.nil?
            render_error('not found', 404)
        else
            render :show, status: :ok
        end
    end

    private

    def message_params
        params.require(:message).permit(:body)
    end

    def set_message
        @message = Message.where(token: params[:application_token], chat_number: params[:chat_number], number: params[:number]).first
    end
end
