json.status @status
json.message @message
json.data do
  json.page @page unless @page.nil?
  json.chats @chats do |msg|
    json.call(msg, :token, :number, :messages_number, :created_at, :updated_at)
  end
  json.total @total
end
