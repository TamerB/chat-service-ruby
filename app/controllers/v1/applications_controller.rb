module V1
  # ApplicationsController handles applications related requests
  class ApplicationsController < ApplicationController
    def create
      prefix = 'Application create'
      logger.info "#{prefix} started: #{application_params}"
      params_not_valid =  validate_params_presence(prefix, ['name'], application_params)
      return params_not_valid unless params_not_valid.nil?

      params_not_valid =  validate_param_no_spaces(prefix, 'name', application_params['name'])
      return params_not_valid unless params_not_valid.nil?

      params_not_valid =  validate_param_length(prefix, 'name', application_params['name'], 5, 20)
      return params_not_valid unless params_not_valid.nil?

      response = $writeClient.call({ action: 'application.create', params: application_params })
      return render_internal_error("#{prefix} cancelled (writer servise not responding): #{application_params}") if response.blank?
      return render_error(response['data'], response['status']) unless response['status'].to_i == 201

      @status = response['status']
      @application = Application.new(response['data'])
      @message = 'Application created successfully'
      render :create, status: :created
    end

    def show
      prefix = 'Application show'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['token'], params)
      return params_not_valid unless params_not_valid.nil?

      @message = 'Application found successfully'
      @status = 200
      application = read_cache("application-#{params['token']}")
      if application.blank?
        response = $readClient.call({ action: 'application.show', params: params['token'] })
        return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}") if response.blank?
        return render_error(response['data'], response['status']) unless response['status'].to_i == 200

        @status = response['status']
        application = response['data']['application'].merge({ chats: response['data']['chats'] })
        write_cache("application-#{application['token']}", application)
      end
      @application = Application.new(application)
      @chats = application[:chats].map { |chat| Chat.new(chat) }
      render :show, status: :ok
    end

    def update
      prefix = 'Application update'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['token', 'name'], params)
      return params_not_valid unless params_not_valid.nil?

      params_not_valid =  validate_param_length(prefix, 'name', params['name'], 5, 20)
      return params_not_valid unless params_not_valid.nil?

      params_not_valid =  validate_param_length(prefix, 'name', params['name'], 5, 20)
      return params_not_valid unless params_not_valid.nil?

      response = $writeClient.call({ action: 'application.update', params: })
      return render_internal_error("#{prefix} cancelled (writer servise not responding) : #{params}") if response.blank?
      return render_error(response['data'], response['status']) unless response['status'].to_i == 200

      remove_cache("application-#{params['token']}")
      @status = response['status']
      @application = Application.new(response['data'])
      @message = 'Application updated successfully'
      render :create, status: :ok
    end

    private

    def application_params
      params.require(:application).permit(:name)
    end
  end
end
