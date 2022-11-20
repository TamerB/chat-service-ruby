json.data do
    json.application do
        json.token @application.token
        json.name @application.name
        json.chats_number @application.chats_number
        json.chats! do
            json.array! @application.chats do |chat|
                json.call(
                    chat,
                    :number,
                    :messages_number
                )
            end
        end
    end
end