require "test_helper"

class V1::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test 'can get application with token' do
    post v1_applications_path, params: { application: { name: 'MyString'}}
    post_response = JSON.parse(response.body)
    get '/v1/applications/' + post_response['data']['application']['token']
    assert_response :ok
    data = JSON.parse(response.body)
    assert_equal false, data['data'].nil?
    assert_equal false, data['data']['application'].nil?
    assert_equal post_response['data']['application']['token'], data['data']['application']['token']
    assert_equal 'MyString', data['data']['application']['name']
    # assert_equal 0, data['data']['application']['chats!'].length()
    # assert_equal 1, data['data']['application']['chats!'][0]['number']
    # assert_equal 2, data['data']['application']['chats!'][1]['number']
  end
  test 'can post application with name' do
    post v1_applications_path, params: { application: { name: 'test1'}}
    assert_response :created
    data = JSON.parse(response.body)
    assert_equal false, data['data'].nil?
    assert_equal false, data['data']['application'].nil?
    assert_equal 'test1', data['data']['application']['name']
  end

  test "can't post application without name" do
    post v1_applications_path, params: { application: {name: nil}}
    assert_response :bad_request
  end
end
