json.status @status
json.message @message
json.data do
    json.chat do |json|
        json.(@message_data, :token, :chat_number, :number, :body, :created_at, :updated_at)
    end
end