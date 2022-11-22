class FixForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :chats, column: :token
    remove_foreign_key :messages, column: :token

    add_foreign_key :chats, :applications, column: :token, primary_key: :token, on_delete: :cascade
    #add_foreign_key :messages, :chats, column: [:token, :chat_number], primary_key: [:token, :number], on_delete: :cascade
    add_index :messages, [:token, :chat_number]
  end
end
