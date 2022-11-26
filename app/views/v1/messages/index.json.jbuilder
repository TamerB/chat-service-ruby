json.status @status
json.message @message
json.data do
    json.messages @messages do |msg|
        json.(msg, :token, :chat_number, :number, :body, :created_at, :updated_at)
    end
end