class Chat < Application
    attr_reader :token, :number, :messages_number, :created_at, :updated_at, :messages
    def initialize(params)
        @token = params['token']
        @number = params['number']
        @messages_number = params['messages_number']
        @created_at = params['created_at']
        @updated_at = params['updated_at']
        @messages = []
    end
end