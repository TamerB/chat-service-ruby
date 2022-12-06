json.status @status
json.message @message
json.data do
    json.page @page unless @page.nil?
    json.messages @messages do |msg|
        json.(msg, :token, :chat_number, :number, :body, :created_at, :updated_at)
    end
    json.total @total unless @total.nil?
end