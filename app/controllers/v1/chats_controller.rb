module V1
  # ChatsController handles chats related requests
  class ChatsController < ApplicationController
    def create
      prefix = 'Chat create'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token'], params)
      return params_not_valid unless params_not_valid.nil?

      response = $writeClient.call({ action: 'chat.create', params: params['application_token'] })
      return render_internal_error("#{prefix} cancelled (writer servise not responding) : #{params}") if response.blank?
      return render_error(response['data'], response['status']) unless response['status'].to_i == 201

      remove_cache("application-#{params['application_token']}")
      remove_cache_pattern("chats-#{params['application_token']}-*")
      @status = response['status']
      @chat = Chat.new(response['data'])
      @message = 'Chat created successfully'
      render :create, status: :created
    end
    
    def index
      prefix = 'Chat index'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token'], params)
      return params_not_valid unless params_not_valid.nil?

      @message = 'Chats found successfully'
      @status = 200
      temp = read_cache("chats-#{params['application_token']}-#{params['page'] || ''}")
      if temp.blank?
        response = $readClient.call({ action: 'chat.index', params: })
        return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}") if response.blank?
        return render_error(response['data'], response['status']) unless response['status'].to_i == 200

        @status = response['status']
        chats = response['data']['chats']
        @total = response['data']['total']
        write_cache("chats-#{params['application_token']}-#{params['page'] || ''}", { chats:, total: @total })
      else
        chats = temp[:chats]
        @total = temp[:total]
      end
      @page = params['page'].to_i unless params['page'].nil?
      @chats = chats.map { |chat| Chat.new(chat) }
      render :index, status: :ok
    end
    
    def show
      prefix = 'Chat show'
      logger.info "#{prefix} started: #{params}"
      params_not_valid =  validate_params_presence(prefix, ['application_token', 'number'], params)
      return params_not_valid unless params_not_valid.nil?

      @message = 'Chat found successfully'
      @status = 200
      chat = read_cache("chat-#{params['application_token']}-#{params['number']}")
      if chat.blank?
        response = $readClient.call({ action: 'chat.show', params: })
        return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}") if response.blank?
        return render_error(response['data'], response['status']) unless response['status'].to_i == 200

        @status = response['status']
        chat = response['data']['chat'].merge({ messages: response['data']['messages'] })
        write_cache("chat-#{chat['token']}-#{chat['number']}", chat)
      end
      @chat = Chat.new(chat)
      @messages = chat[:messages].map { |msg| Message.new(msg) }
      render :show, status: :ok
    end
  end
end
