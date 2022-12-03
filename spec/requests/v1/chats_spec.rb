require 'swagger_helper'

RSpec.describe 'v1/chats', type: :request do

  path '/v1/applications/{application_token}/chats' do
    parameter name: 'application_token', in: :path, type: :string, description: 'application token'

    post "create chat" do
      tags "chats"
      produces "application/json"
      response '201', 'chat created' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                chat: { type: :object,
                  properties: {
                    token: { type: :string },
                    number: { type: :integer },
                    messages_number: { type: :integer },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response "400", "bad request" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
      end
      response "404", "chat not found" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
      end
    end
  end

  path '/v1/applications/{application_token}/chats/{number}' do
    # You'll want to customize the parameter types...
    parameter name: 'application_token', in: :path, type: :string, description: 'application token'
    parameter name: 'number', in: :path, type: :string, description: 'chat number'

    get('show chat') do
      tags "chats"
      produces "application/json"
      response '200', 'chat found' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                chat: { type: :object,
                  properties: {
                    token: { type: :string },
                    number: { type: :integer },
                    messages_number: { type: :integer },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }
        let(:number) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response "404", "chat not found" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
      end
    end
  end
end
