class V1::ApplicationsController < ApplicationController
    include V1::ErrorResponses::Response

    def create
        response = $writeClient.call({action: 'application.create', params: application_params})
        if response['status'].to_i == 201
            @application = response['data']
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def show
        response = $readClient.call({action: 'application.show', params: params['token']})
        if response['status'].to_i == 200
            @application = response['data']['application']
            @application['chats'] = response['data']['chats']
            render :show, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def update
        response = $writeClient.call({action: 'application.update', params: params})
        if response['status'].to_i == 200
            @application = response['data']
            render :create, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    private

    def application_params
        params.require(:application).permit(:name)
    end
end
