json.status @status
json.message @message
json.data do
  json.message do |json|
    json.call(@message_data, :token, :chat_number, :number, :body, :created_at, :updated_at)
  end
end
