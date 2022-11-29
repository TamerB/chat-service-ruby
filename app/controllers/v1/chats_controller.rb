class V1::ChatsController < ApplicationController
    include V1::ErrorResponses::Response

    def create
        return render_error('token is required', 400) if params['application_token'].nil?
        response = $writeClient.call({action: 'chat.create', params: params['application_token']})
        @status = response['status']
        if response['status'].to_i == 201
            @chat = Chat.new(response['data'])
            @message = 'Chat created successfully'
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def show
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['number'].nil?
        response = $readClient.call({action: 'chat.show', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            @chat = Chat.new(response['data']['chat'])
            @chat.set_messages(response['data']['messages'])
            @message = 'Chat found successfully'
            render :show, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end
end
