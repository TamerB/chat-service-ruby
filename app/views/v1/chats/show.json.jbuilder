json.data do
    json.chat do
        json.call(
            @chat,
            :token,
            :number,
            :messages_number
        )
    end
end