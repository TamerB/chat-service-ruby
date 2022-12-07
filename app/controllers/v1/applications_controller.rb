class V1::ApplicationsController < ApplicationController
    def create
        prefix = 'Application create'
        logger.info "#{prefix} started: #{application_params}"
        response = $writeClient.call({action: 'application.create', params: application_params})
        if response.blank?
            return render_internal_error("#{prefix} cancelled (writer servise not responding): #{application_params}")
        end
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
        prefix = 'Application show'
        logger.info "#{prefix} started: #{params}"
        if params['token'].blank?
            logger.warn "#{prefix} cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        @message = 'Application found successfully'
        @status = 200
        application = read_cache('application-' + params['token'])
        if application.blank?
            response = $readClient.call({action: 'application.show', params: params['token']})
            if response.blank?
                return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}")
            end
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
        prefix = 'Application update'
        logger.info "#{prefix} started: #{params}"
        if params['token'].blank?
            logger.warn "#{prefix} cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        response = $writeClient.call({action: 'application.update', params: params})
        if response.blank?
            return render_internal_error("#{prefix} cancelled (writer servise not responding) : #{params}")
        end
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
