json.status @status
json.message @message
json.data do
    json.chat do |json|
        json.(@chat, :token, :number, :messages_number, :created_at, :updated_at)
        json.messages @chat.messages, :number, :body, :created_at, :updated_at
    end
end