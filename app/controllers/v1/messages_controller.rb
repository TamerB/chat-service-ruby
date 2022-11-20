class V1::MessagesController < ApplicationController
    before_action :set_message, only: [:show, :update]
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    def create
        chat = Chat.where(token: params[:application_token], number: params[:chat_number]).first
        if chat.nil?
            record_not_found
        elsif params[:body].nil?
            @message = 'body is required'
            @status = 400
            render :error, status: :bad_request
        else
            @message = Message.new(token: chat.token, chat_number: chat.number, body: params[:body])
            if @message.save
                render :create, status: :created
            else
                @message = 'missing required values'
                @status = 400
                render :error, status: :bad_request
            end
        end
    end

    def update
        if params[:body].nil?
            @message = 'body is required'
            @status = 400
            render :error, status: :bad_request
        else
            if @message.update(message_params)
                @status = 'ok'
                render :create, status: :ok
            else
                @message = 'unprocessable entity'
                @status = 422
                render :error, status: :unprocessable_entity
            end
        end
    end

    def index
        @messages = Message.where(token: params[:application_token], chat_number: params[:chat_number]).order('created_at')
        render :index, status: :ok
    end

    def show
        if @message.nil?
            record_not_found
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

    def record_not_found
        @message = 'not found'
        @status = 404
        render :error, status: :not_found
    end
end
