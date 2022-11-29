require "test_helper"

class V1::ChatsControllerTest < ActionDispatch::IntegrationTest
  test 'can get chat with token and number' do
    post v1_applications_path, params: { application: { name: 'MyString'}}
    assert_response :created
    post_response = JSON.parse(response.body)

    post v1_application_chats_path(application_token: post_response['data']['application']['token'])
    assert_response :created

    get v1_application_chat_path(application_token: post_response['data']['application']['token'], number: 1)
    assert_response :ok
    data = JSON.parse(response.body)
    assert_equal false, data['data'].nil?
    assert_equal false, data['data']['chat'].nil?
    assert_equal post_response['data']['application']['token'], data['data']['chat']['token']
    assert_equal 1, data['data']['chat']['number']
    # assert_equal 1, data['data']['chat']['messages!'].length()
    # assert_equal 1, data['data']['chat']['messages!'][0]['number']
    # assert_equal 'MyText', data['data']['chat']['messages!'][0]['body']
    # assert_equal 2, data['data']['chat']['messages!'][1]['number']
    # assert_equal 'MyText', data['data']['chat']['messages!'][1]['body']
  end
  test "can't post chat with token that doesn't exist" do
    post v1_application_chats_path(application_token: '1452668'), params: { application: { application_token: '41575952'}}
    assert_response :not_found
  end
end
