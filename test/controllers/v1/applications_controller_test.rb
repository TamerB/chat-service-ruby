require "test_helper"

class V1::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test 'can get application with token abc' do
    get '/v1/applications/abc'
    assert_response :ok
  end
  test 'can post application with name' do
    post v1_applications_path, params: { application: { name: 'test1'}}
    assert_response :created
  end

  test "can't post application without name" do
    post v1_applications_path, params: { application: {name: nil}}
    assert_response :bad_request
  end
  # test "the truth" do
  #   assert true
  # end
end
