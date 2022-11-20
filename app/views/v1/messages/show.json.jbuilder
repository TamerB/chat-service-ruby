json.data do
    json.message do
        json.call(
            @message,
            :token,
            :chat_number,
            :number,
            :body
        )
    end
end