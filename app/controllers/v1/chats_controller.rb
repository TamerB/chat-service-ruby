class V1::ChatsController < ApplicationController
    def create
        return render_error('token is required', 400) if params['application_token'].nil?
        response = $writeClient.call({action: 'chat.create', params: params['application_token']})
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
        return render_error('token is required', 400) if params['application_token'].nil?
        @message = 'Chats found successfully'
        @status = 200
        temp = read_cache('chats-' + params['application_token'] + '-' + (params['page'] || ''))
        if temp.blank?
            response = $readClient.call({action: 'chat.index', params: params})
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
        return render_error('token is required', 400) if params['application_token'].nil?
        return render_error('chat number is required', 400) if params['number'].nil?
        @message = 'Chat found successfully'
        @status = 200
        chat = read_cache('chat-' + params['application_token'] + '-' + params['number'])
        if chat.blank?
            response = $readClient.call({action: 'chat.show', params: params})
            @status = response['status']
            if response['status'].to_i == 200
                chat = response['data']['chat'].merge({messages: response['data']['messages']})
                write_cache('chat-' + chat['token'] + '-' + chat['number'], chat)
            else
                return render_error(response['data'], response['status'])
            end
        end
        @chat = Chat.new(chat)
        @messages = chat['messages'].map{|m| Message.new(msg)}
        render :show, status: :ok
    end
end
