class V1::MessagesController < ApplicationController
    include V1::ErrorResponses::Response
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}

    def create
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['chat_number'].nil?
        return render_error('body is required', 400) if params['body'].nil?
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
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['chat_number'].nil?
        return render_error('message number is required', 400) if params['number'].nil?
        return render_error('body is required', 400) if params['body'].nil?
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
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['chat_number'].nil?
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
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['chat_number'].nil?
        return render_error('message number is required', 400) if params['number'].nil?
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
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['chat_number'].nil?
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
