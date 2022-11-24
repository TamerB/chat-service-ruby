class V1::MessagesController < ApplicationController
    include V1::ErrorResponses::Response
    rescue_from ActiveRecord::RecordNotFound, with: -> {render_error('not found', 404)}

    def create
        response = $writeClient.call({action: 'message.create', params: params})
        if response['status'].to_i == 201
            @message = response['data']
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def update
        response = $writeClient.call({action: 'message.update', params: params})
        if response['status'].to_i == 200
            @message = response['data']
            render :create, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def index
        response = $readClient.call({action: 'message.index', params: params})
        if response['status'].to_i == 200
            @messages = response['data']
            render :index, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def show
        response = $readClient.call({action: 'message.show', params: params})
        if response['status'].to_i == 200
            @message = response['data']
            render :show, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end
end
