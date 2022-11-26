class Message < Chat
    attr_reader :id, :token, :chat_number, :number, :body, :created_at, :updated_at
    def initialize(params)
        @id = params['id']
        @token = params['token']
        @chat_number = params['chat_number']
        @number = params['number']
        @body = params['body']
        @created_at = params['created_at']
        @updated_at = params['updated_at']
    end
end