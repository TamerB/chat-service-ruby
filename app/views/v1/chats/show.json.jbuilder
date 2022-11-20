json.data do
    json.chat do
        json.token @chat.token
        json.number @chat.number
        json.messages_number @chat.messages_number
        json.messages! do
            json.array! @chat.messages do |message|
                json.call(
                    message,
                    :number,
                    :body
                )
            end
        end
    end
end