module V1
  # MessagesController handles messages related requests
  class MessagesController < ApplicationController
    def create
      prefix = 'Message create'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token', 'chat_number', 'body'], params)
      return params_not_valid unless params_not_valid.nil?

      response = $writeClient.call({ action: 'message.create', params: })
      return render_internal_error("#{prefix} cancelled (writer servise not responding) : #{params}") if response.blank?
      return render_error(response['data'], response['status']) unless response['status'].to_i == 201

      remove_cache("chat-#{params['application_token']}-#{params['chat_number']}")
      remove_cache_pattern("msgs-#{params['application_token']}-#{params['chat_number']}-*")
      @status = response['status']
      @message_data = Message.new(response['data'])
      @message = 'Message created successfully'
      render :create, status: :created
    end

    def update
      prefix = 'Message update'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token', 'chat_number', 'number', 'body'], params)
      return params_not_valid unless params_not_valid.nil?

      response = $writeClient.call({ action: 'message.update', params: })
      return render_internal_error("#{prefix} cancelled (writer servise not responding) : #{params}") if response.blank?
      return render_error(response['data'], response['status']) unless response['status'].to_i == 200

      remove_cache("chat-#{params['application_token']}-#{params['chat_number']}")
      remove_cache_pattern("msgs-#{params['application_token']}-#{params['chat_number']}-*")
      remove_cache("msg-#{params['application_token']}-#{params['chat_number']}-#{params['number']}")
      @status = response['status']
      @message_data = Message.new(response['data'])
      @message = 'Message updated successfully'
      render :create, status: :ok
    end

    def index
      prefix = 'Messages index'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token', 'chat_number'], params)
      return params_not_valid unless params_not_valid.nil?

      @message = 'Messages found successfully'
      @status = 200
      temp = read_cache("msgs-#{params['application_token']}-#{params['chat_number']}-#{params['page'] || ''}")
      if temp.blank?
        response = $readClient.call({ action: 'message.index', params: })
        return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}") if response.blank?
        return render_error(response['data'], response['status']) unless  response['status'].to_i == 200

        @status = response['status']
        messages = response['data']['messages']
        @total = response['data']['total']
        write_cache("msgs-#{params['application_token']}-#{params['chat_number']}-#{params['page'] || ''}", { messages: messages, total: @total })
      else
        messages = temp[:messages]
        @total = temp[:total]
      end
      @page = params['page'].to_i unless params['page'].nil?
      @messages = messages.map { |msg| Message.new(msg) }
      render :index, status: :ok
    end

    def show
      prefix = 'Message show'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token', 'chat_number', 'number'], params)
      return params_not_valid unless params_not_valid.nil?

      @message = 'Message found successfully'
      @status = 200
      message_data = read_cache("msg-#{params['application_token']}-#{params['chat_number']}-#{params['number']}")
      if message_data.blank?
        response = $readClient.call({ action: 'message.show', params: })
        return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}") if response.blank?
        return render_error(response['data'], response['status']) unless response['status'].to_i == 200

        @status = response['status']
        message_data = response['data']
        write_cache("msg-#{params['application_token']}-#{params['chat_number']}-#{params['number']}", message_data)
      end
      @message_data = Message.new(message_data)
      render :show, status: :ok
    end

    def search
      prefix = 'Message search'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token', 'chat_number'], params)
      return params_not_valid unless params_not_valid.nil?

      @message = 'Messages found successfully'
      @status = 200
      temp = read_cache("msgs-#{params['application_token']}-#{params['chat_number']}-search-#{params['page'] || ''}")
      if temp.blank?
        response = $readClient.call({ action: 'message.search', params: })
        return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}") if response.blank?
        return render_error(response['data'], response['status']) unless response['status'].to_i == 200

        @status = response['status']
        messages = response['data']['messages']
        messages_data = { messages: }
        unless response['data']['total'].nil?
          @total = response['data']['total']
          messages_data[:total] = @total
        end
        write_cache("msgs-#{params['application_token']}-#{params['chat_number']}-search-#{params['page'] || ''}", messages_data)
      else
        messages = temp[:messages]
        @total = temp[:total]
      end
      @page = params['page'].to_i unless params['page'].nil?
      @messages = messages.map { |msg| Message.new(msg) }
      render :index, status: :ok
    end
  end
end
