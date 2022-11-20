require "test_helper"

class V1::ChatsControllerTest < ActionDispatch::IntegrationTest
  test 'can get chat with token one and number 1' do
    get '/v1/applications/abc/chats/2'
    assert_response :ok
    data = JSON.parse(response.body)
    assert_equal 'abc', data['data']['chat']['token']
    assert_equal 2, data['data']['chat']['number']
    assert_equal 2, data['data']['chat']['messages!'].length()
    assert_equal 1, data['data']['chat']['messages!'][0]['number']
    assert_equal 'MyText', data['data']['chat']['messages!'][0]['body']
    assert_equal 2, data['data']['chat']['messages!'][1]['number']
    assert_equal 'MyText', data['data']['chat']['messages!'][1]['body']
  end
  test "can't post chat with token that doesn't exist" do
    post '/v1/applications/abcdef/chats'
    assert_response :not_found
  end
end
