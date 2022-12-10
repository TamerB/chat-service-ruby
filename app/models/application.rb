class Application
    attr_reader :token, :name, :chats_number, :created_at, :updated_at, :chats
    def initialize(params)
        @token = params['token']
        @name = params['name']
        @chats_number = params['chats_number']
        @created_at = params['created_at']
        @updated_at = params['updated_at']
        @chats = []
    end
end