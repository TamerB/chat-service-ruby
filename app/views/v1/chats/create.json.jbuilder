json.status @status
json.message @message
json.data do
  json.chat do |json|
    json.call(@chat, :token, :number, :messages_number, :created_at, :updated_at)
  end
end
