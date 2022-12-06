class V1::ApplicationsController < ApplicationController
    def create
        logger.info "Application create started: #{application_params}"
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
        logger.info "Application show started: #{params}"
        if params['token'].blank?
            logger.warn "Application show cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        @message = 'Application found successfully'
        @status = 200
        application = read_cache('application-' + params['token'])
        if application.blank?
            response = $readClient.call({action: 'application.show', params: params['token']})
            @status = response['status']
            if response['status'].to_i == 200
                application = response['data']['application'].merge({chats: response['data']['chats']})
                write_cache('application-' + application['token'], application)
            else
                return render_error(response['data'], response['status'])
            end
        end
        @application = Application.new(application)
        @chats = application[:chats].map{|chat| Chat.new(chat)}
        render :show, status: :ok
    end

    def update
        logger.info "Application update started: #{application_params}"
        if params['token'].blank?
            logger.warn "Application update cancelled (token is required): #{application_params}"
            return render_error('token is required', 400)
        end
        response = $writeClient.call({action: 'application.update', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            remove_cache('application-' + params['token'])
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
