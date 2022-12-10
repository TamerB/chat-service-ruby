json.status @status
json.message @message
json.data do
  json.application do |json|
    json.call(@application, :token, :name, :chats_number, :created_at, :updated_at)
  end
end
