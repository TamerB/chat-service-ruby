json.data do
    json.application do
        json.call(
            @application,
            :token,
            :name,
            :chats_number
        )
    end
end