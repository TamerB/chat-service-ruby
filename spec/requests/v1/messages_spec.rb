require 'swagger_helper'

RSpec.describe 'v1/messages', type: :request do

  path '/v1/applications/{application_token}/chats/{chat_number}/messages' do
    # You'll want to customize the parameter types...
    parameter name: 'application_token', in: :path, type: :string, description: 'application token'
    parameter name: 'chat_number', in: :path, type: :string, description: 'chat number'

    post "create message" do
      tags "messages"
      consumes "application/json"
      produces "application/json"
      parameter name: :message, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string },
        },
        required: ["body"],
      }
      response '201', 'message created' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                message: { type: :object,
                  properties: {
                    id: { type: :integer },
                    token: { type: :string },
                    chat_number: { type: :integer },
                    number: { type: :integer },
                    messages_number: { type: :integer },
                    body: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }
        let(:chat_number) { '123' }

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
      response "404", "not found" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
      end
    end

    get('list messages') do
      tags "messages"
      produces "application/json"
      response '200', 'Appliction found' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                messages: { type: :array,
                  items: { type: :object,
                    properties: {
                      token: { type: :string },
                      chat_number: { type: :integer },
                      number: { type: :integer },
                      messages_number: { type: :integer },
                      body: { type: :string },
                      created_at: { type: :string },
                      updated_at: { type: :string }
                    }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }
        let(:chat_number) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response "404", "not found" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
      end
    end
  end

  path '/v1/applications/{application_token}/chats/{chat_number}/messages/{number}' do
    # You'll want to customize the parameter types...
    parameter name: 'application_token', in: :path, type: :string, description: 'application token'
    parameter name: 'chat_number', in: :path, type: :string, description: 'chat number'
    parameter name: 'number', in: :path, type: :string, description: 'message number'

    get('show message') do
      tags "messages"
      produces "application/json"
      response '200', 'message found' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                message: { type: :object,
                  properties: {
                    token: { type: :string },
                    chat_number: { type: :integer },
                    number: { type: :integer },
                    messages_number: { type: :integer },
                    body: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }
        let(:chat_number) { '123' }
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
      response "404", "message not found" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
      end
    end

    put('update message') do
      tags "messages"
      consumes "application/json"
      produces "application/json"
      parameter name: :message, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string },
        },
        required: ["body"],
      }
      response(200, 'message updated') do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                message: { type: :object,
                  properties: {
                    token: { type: :string },
                    chat_number: { type: :integer },
                    number: { type: :integer },
                    messages_number: { type: :integer },
                    body: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }
        let(:chat_number) { '123' }
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
    end
  end

  path '/v1/applications/{application_token}/chats/{chat_number}/search/{phrase}' do
    # You'll want to customize the parameter types...
    parameter name: 'application_token', in: :path, type: :string, description: 'application_ token'
    parameter name: 'chat_number', in: :path, type: :string, description: 'chat number'
    parameter name: 'phrase', in: :path, type: :string, description: 'search phrase'

    get('search message') do
      tags "messages"
      consumes "application/json"
      produces "application/json"
      response '200', 'messages found' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                messages: { type: :array,
                  items: { type: :object,
                    properties: {
                      token: { type: :string },
                      chat_number: { type: :integer },
                      number: { type: :integer },
                      messages_number: { type: :integer },
                      body: { type: :string },
                      created_at: { type: :string },
                      updated_at: { type: :string }
                    }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application_token) { '123' }
        let(:chat_number) { '123' }
        let(:phrase) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response "404", "not found" do
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