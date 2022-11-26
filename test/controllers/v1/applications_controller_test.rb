require "test_helper"

class V1::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  # test 'can get application with token abc' do
  #   get '/v1/applications/abc'
  #   assert_response :ok
  #   data = JSON.parse(response.body)
  #   assert_equal 'abc', data['data']['application']['token']
  #   assert_equal 'MyString', data['data']['application']['name']
  #   assert_equal 2, data['data']['application']['chats!'].length()
  #   assert_equal 1, data['data']['application']['chats!'][0]['number']
  #   assert_equal 2, data['data']['application']['chats!'][1]['number']
  # end
  # test 'can post application with name' do
  #   post v1_applications_path, params: { application: { name: 'test1'}}
  #   assert_response :created
  #   data = JSON.parse(response.body)
  #   assert_equal 'test1', data['data']['application']['name']
  # end

  # test "can't post application without name" do
  #   post v1_applications_path, params: { application: {name: nil}}
  #   assert_response :bad_request
  # end
end
