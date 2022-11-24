class V1::ChatsController < ApplicationController
    include V1::ErrorResponses::Response

    def create
        response = $writeClient.call({action: 'chat.create', params: params['application_token']})
        if response['status'].to_i == 201
            @chat = response['data']
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def show
        response = $readClient.call({action: 'chat.show', params: params})
        if response['status'].to_i == 200
            @chat = response['data']['chat']
            @chat['messages'] = response['data']['messages']
            render :show, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end
end
