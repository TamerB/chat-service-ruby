require "test_helper"

class V1::MessagesControllerTest < ActionDispatch::IntegrationTest
  test 'can post message with required fields' do
    post v1_applications_path, params: { application: { name: 'MyString'}}
    application_response = JSON.parse(response.body)

    post '/v1/applications/' + application_response['data']['application']['token'] + '/chats'

    post '/v1/applications/' + application_response['data']['application']['token'] + '/chats/1/messages', params: { body: 'test text' }
    assert_response :created
    data = JSON.parse(response.body)
    assert_equal false, data['data'].nil?
    assert_equal false, data['data']['message'].nil?
    assert_equal application_response['data']['application']['token'], data['data']['message']['token']
    assert_equal 1, data['data']['message']['chat_number']
    assert_equal 'test text', data['data']['message']['body']
  end
  test 'can get message with number' do
    post v1_applications_path, params: { application: { name: 'MyString'}}
    application_response = JSON.parse(response.body)
    post '/v1/applications/' + application_response['data']['application']['token'] + '/chats'
    post '/v1/applications/' + application_response['data']['application']['token'] + '/chats/1/messages', params: { body: 'test text' }

    get '/v1/applications/' + application_response['data']['application']['token'] + '/chats/1/messages/1'
    assert_response :ok
    data = JSON.parse(response.body)
    assert_equal false, data['data'].nil?
    assert_equal false, data['data']['message'].nil?
    assert_equal application_response['data']['application']['token'], data['data']['message']['token']
    assert_equal 1, data['data']['message']['chat_number']
    assert_equal 1, data['data']['message']['number']
    assert_equal 'test text', data['data']['message']['body']
  end

  test "can't post message without body" do
    post '/v1/applications/def/chats/1/messages', params: { body: nil}
    assert_response :bad_request
  end
  # test 'can update message with required fields' do
  #   put '/v1/applications/abc/chats/2/messages/1', params: { message: {body: 'test text'}, body: 'test text 123' }
  #   assert_response :ok

  #   data = JSON.parse(response.body)
  #   assert_equal 'test text', data['data']['message']['body']
  # end
end
