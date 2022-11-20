require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "should not save message without token" do
    message = Message.new(chat_number: 2, body: 'test text')
    assert_not message.save, "Saved the message without a token"
  end

  test "should save message with required fields" do
    message = Message.new(token: 'def', chat_number: 1, body: 'test text', number: 1)
    assert message.save, "Saved the message with required fields"
  end
  test "should update message with required fields" do
    m = Message.all
    m.each do |me|
    end
    message = Message.new(token: 'def', chat_number: 1, body: 'test text', number: 1)
    assert message.save, "Saved the message with required fields"
  end
end
