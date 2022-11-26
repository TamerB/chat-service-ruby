class V1::MessagesController < ApplicationController
    include V1::ErrorResponses::Response
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}

    def create
        response = $writeClient.call({action: 'message.create', params: params})
        @status = response['status']
        if response['status'].to_i == 201
            @message_data = Message.new(response['data'])
            @message = 'Message created successfully'
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def update
        response = $writeClient.call({action: 'message.update', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            @message_data = Message.new(response['data'])
            @message = 'Message updated successfully'
            render :create, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def index
        response = $readClient.call({action: 'message.index', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            @messages = response['data']['messages'].map{|msg| Message.new(msg)}
            @message = 'Messages found successfully'
            render :index, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def show
        response = $readClient.call({action: 'message.show', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            @message_data = Message.new(response['data'])
            @message = 'Message found successfully'
            render :show, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def search
        response = $readClient.call({action: 'message.search', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            @messages = response['data'].map{|message| Message.new(message)}
            @message = 'Messages found successfully'
            render :index, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end
end
