require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "should not save chat without token" do
    chat = Chat.new
    assert_not chat.save, "Saved the chat without a token"
  end

  test "should save chat with token" do
    chat = Chat.new
    chat.token = 'def'
    assert chat.save, "Saved the chat with a token"
  end
end