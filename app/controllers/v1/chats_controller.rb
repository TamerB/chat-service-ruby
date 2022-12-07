class V1::ChatsController < ApplicationController
    def create
        prefix = "Chat create"
        logger.info "#{prefix} started: #{params}"
        if params['application_token'].blank?
            logger.warn "#{prefix} cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        response = $writeClient.call({action: 'chat.create', params: params['application_token']})
        if response.blank?
            return render_internal_error("#{prefix} cancelled (writer servise not responding) : #{params}")
        end
        @status = response['status']
        if response['status'].to_i == 201
            remove_cache('application-' + params['application_token'])
            remove_cache_pattern("chats-#{params['application_token']}-*")
            @chat = Chat.new(response['data'])
            @message = 'Chat created successfully'
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def index
        prefix = "Chat index"
        logger.info "#{prefix} started: #{params}"
        if params['application_token'].blank?
            logger.warn "#{prefix} cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        @message = 'Chats found successfully'
        @status = 200
        temp = read_cache('chats-' + params['application_token'] + '-' + (params['page'] || ''))
        if temp.blank?
            response = $readClient.call({action: 'chat.index', params: params})
            if response.blank?
                return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}")
            end
            @status = response['status']
            if response['status'].to_i == 200
                chats = response['data']['chats']
                @total = response['data']['total']
                write_cache('chats-' + params['application_token'] + '-' + (params['page'] || ''), {chats: chats, total: @total})
            else
                return render_error(response['data'], response['status'])
            end
        else
            chats = temp[:chats]
            @total = temp[:total]
        end
        @page = params['page'].to_i unless params['page'].nil?
        @chats = chats.map{|chat| Chat.new(chat)}
        render :index, status: :ok
    end

    def show
        prefix = "Chat show"
        logger.info "#{prefix} started: #{params}"
        if params['application_token'].blank?
            logger.warn "#{prefix} cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        if params['number'].blank?
            logger.warn "#{prefix} cancelled (chat number is required): #{params}"
            return render_error('chat number is required', 400)
        end
        @message = 'Chat found successfully'
        @status = 200
        chat = read_cache('chat-' + params['application_token'] + '-' + params['number'])
        if chat.blank?
            response = $readClient.call({action: 'chat.show', params: params})
            if response.blank?
                return render_internal_error("#{prefix} cancelled (reader servise not responding) : #{params}")
            end
            @status = response['status']
            if response['status'].to_i == 200
                chat = response['data']['chat'].merge({messages: response['data']['messages']})
                write_cache("chat-#{chat['token']}-#{chat['number']}", chat)
            else
                return render_error(response['data'], response['status'])
            end
        end
        @chat = Chat.new(chat)
        @messages = chat[:messages].map{|msg| Message.new(msg)}
        render :show, status: :ok
    end
end
