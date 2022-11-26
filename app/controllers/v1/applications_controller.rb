class V1::ApplicationsController < ApplicationController
    include V1::ErrorResponses::Response

    def create
        response = $writeClient.call({action: 'application.create', params: application_params})
        @status = response['status']
        if response['status'].to_i == 201
            @application = Application.new(response['data'])
            @message = 'Application created successfully'
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def show
        response = $readClient.call({action: 'application.show', params: params['token']})
        @status = response['status']
        if response['status'].to_i == 200
            @application = Application.new(response['data']['application'])
            @application.set_chats(response['data']['chats'])
            @message = 'Application found successfully'
            render :show, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def update
        response = $writeClient.call({action: 'application.update', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            @application = Application.new(response['data'])
            @message = 'Application updated successfully'
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
