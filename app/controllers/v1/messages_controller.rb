class V1::MessagesController < ApplicationController
    def create
        logger.info "Message create started: #{params}"
        if params['application_token'].blank?
            logger.warn "Message create cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        if params['chat_number'].blank?
            logger.warn "Message create cancelled (chat number is required): #{params}"
            return render_error('chat number is required', 400)
        end
        if params['body'].blank?
            logger.warn "Message create cancelled (body is required): #{params}"
            return render_error('body is required', 400)
        end
        response = $writeClient.call({action: 'message.create', params: params})
        @status = response['status']
        if response['status'].to_i == 201
            remove_cache('chat-' + params['application_token'] + '-' + params['chat_number'])
            remove_cache_pattern("msgs-#{params['application_token']}-#{params['chat_number']}-*")
            @message_data = Message.new(response['data'])
            @message = 'Message created successfully'
            render :create, status: :created
        else
            render_error(response['data'], response['status'])
        end
    end

    def update
        logger.info "Message update started: #{params}"
        if params['application_token'].blank?
            logger.warn "Message update cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        if params['chat_number'].blank?
            logger.warn "Message update cancelled (chat number is required): #{params}"
            return render_error('chat number is required', 400)
        end
        if params['number'].blank?
            logger.warn "Message update cancelled (message number is required): #{params}"
            return render_error('message number is required', 400)
        end
        if params['body'].blank?
            logger.warn "Message update cancelled (body is required): #{params}"
            return render_error('body is required', 400)
        end
        response = $writeClient.call({action: 'message.update', params: params})
        @status = response['status']
        if response['status'].to_i == 200
            remove_cache('chat-' + params['application_token'] + '-' + params['chat_number'])
            remove_cache_pattern("msgs-#{params['application_token']}-#{params['chat_number']}-*")
            remove_cache('msg-' + params['application_token'] + '-' + params['chat_number'] + '-' + params['number'])
            @message_data = Message.new(response['data'])
            @message = 'Message updated successfully'
            render :create, status: :ok
        else
            render_error(response['data'], response['status'])
        end
    end

    def index
        logger.info "Messages index started: #{params}"
        if params['application_token'].blank?
            logger.warn "Messages index cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        if params['chat_number'].blank?
            logger.warn "Messages index cancelled (chat number is required): #{params}"
            return render_error('chat number is required', 400)
        end
        @message = 'Messages found successfully'
        @status = 200
        temp = read_cache('msgs-' + params['application_token'] + '-' + params['chat_number'] + '-' + (params['page'] || ''))
        if temp.blank?
            response = $readClient.call({action: 'message.index', params: params})
            @status = response['status']
            if response['status'].to_i == 200
                messages = response['data']['messages']
                @total = response['data']['total']
                write_cache('msgs-' + params['application_token'] + '-' + params['chat_number'] + '-' + (params['page'] || ''), {messages: messages, total: @total})
            else
                return render_error(response['data'], response['status'])
            end
        else
            messages = temp[:messages]
            @total = temp[:total]
        end
        @page = params['page'].to_i unless params['page'].nil?
        @messages = messages.map{|msg| Message.new(msg)}
        render :index, status: :ok
    end

    def show
        logger.info "Message show started: #{params}"
        if params['application_token'].blank?
            logger.warn "Message show cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        if params['chat_number'].blank?
            logger.warn "Message show cancelled (chat number is required): #{params}"
            return render_error('chat number is required', 400)
        end
        if params['number'].blank?
            logger.warn "Message show cancelled (message number is required): #{params}"
            return render_error('message number is required', 400)
        end
        @message = 'Message found successfully'
        @status = 200
        message_data = read_cache('msg-' + params['application_token'] + '-' + params['chat_number'] + '-' + params['number'])
        if message_data.blank?
            response = $readClient.call({action: 'message.show', params: params})
            @status = response['status']
            if response['status'].to_i == 200
                message_data = response['data']
                write_cache('msg-' + params['application_token'] + '-' + params['chat_number'] + '-' + params['number'], message_data)
            else
                return render_error(response['data'], response['status'])
            end
        end
        @message_data = Message.new(message_data)
        render :show, status: :ok
    end

    def search
        logger.info "Messages search started: #{params}"
        if params['application_token'].blank?
            logger.warn "Messages search cancelled (token is required): #{params}"
            return render_error('token is required', 400)
        end
        if params['chat_number'].blank?
            logger.warn "Messages search cancelled (chat number is required): #{params}"
            return render_error('chat number is required', 400)
        end
        @message = 'Messages found successfully'
        @status = 200
        temp = read_cache('msgs-' + params['application_token'] + '-' + params['chat_number'] + '-' + 'search-' + (params['page'] || ''))
        if temp.blank?
            response = $readClient.call({action: 'message.search', params: params})
            @status = response['status']
            if response['status'].to_i == 200
                messages = response['data']['messages']
                messages_data = {messages: messages}
                unless response['data']['total'].nil?
                    @total = response['data']['total']
                    messages_data[:total] = @total
                end
                write_cache('msgs-' + params['application_token'] + '-' + params['chat_number'] + '-' + 'search-' + (params['page'] || ''), messages_data)
            else
                return render_error(response['data'], response['status'])
            end
        else
            messages = temp[:messages]
            @total = temp[:total]
        end
        @page = params['page'].to_i unless params['page'].nil?
        @messages = messages.map{|msg| Message.new(msg)}
        render :index, status: :ok
    end
end
