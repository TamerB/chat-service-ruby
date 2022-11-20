require "test_helper"

class V1::ChatsControllerTest < ActionDispatch::IntegrationTest
  test 'can get chat with token one and number 1' do
    get '/v1/applications/one/chats/1'
    assert_response :ok
  end
  test "can't post chat with token that doesn't exist" do
    post '/v1/applications/abcdef/chats'
    assert_response :not_found
  end
end
