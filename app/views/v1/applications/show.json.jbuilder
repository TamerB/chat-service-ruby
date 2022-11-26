json.status @status
json.message @message
json.data do
    json.application do |json|
        json.(@application, :token, :name, :chats_number, :created_at, :updated_at)
        json.chats @application.chats, :number, :messages_number, :created_at, :updated_at
    end
end