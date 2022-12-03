require 'swagger_helper'

RSpec.describe 'v1/applications', type: :request do

  path "/v1/applications" do
    post "create application" do
      tags "applications"
      consumes "application/json"
      produces "application/json"
      parameter name: :application, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, minLength: 5, maxLength: 20 },
        },
        required: ["name"],
      }
      response '201', 'appliction created' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                application: { type: :object,
                  properties: {
                    token: { type: :string },
                    name: { type: :string },
                    chats_number: { type: :integer },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:name) { 'abcdef' }

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
    end
  end

  path "/v1/applications/{token}" do
    parameter name: 'token', in: :path, type: :string, description: 'application token'

    get "get application" do
      tags "applications"
      produces 'application/json'
      response '200', 'appliction found' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                application: { type: :object,
                  properties: {
                    token: { type: :string },
                    name: { type: :string },
                    chats_number: { type: :integer },
                    created_at: { type: :string },
                    updated_at: { type: :string },
                    chats: { type: :array,
                       items: { type: :object,
                        properties: {
                          number: { type: :integer },
                          messages_number: { type: :integer },
                          created_at: { type: :string },
                          updated_at: { type: :string }
                        }
                      }
                    }

                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:token) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response "404", "application not found" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
        let(:application) { { token: 'foo' } }
        run_test!
      end
    end

    put "update application" do
      tags "applications"
      consumes "application/json"
      produces "application/json"
      parameter name: :application, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, minLength: 5, maxLength: 20 },
        },
        required: ["name"],
      }
      response '200', 'appliction updated' do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string },
            data: { type: :object,
              properties: {
                application: { type: :object,
                  properties: {
                    token: { type: :string },
                    name: { type: :string },
                    chats_number: { type: :integer },
                    created_at: { type: :string },
                    updated_at: { type: :string }
                  }
                }
              }
            }
          },
          required: [ 'status', 'message' ]
        let(:application) { { name: 'foo-foo', token: 'foo-foo' } }
        run_test!
      end
      response "400", "bad request" do
        schema type: :object,
          properties: {
            status: { type: :string },
            message: { type: :string }
          },
          required: [ 'status', 'message' ]
        let(:token) { '123' }
        let(:name) { 'fedcba' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response "404", "application not found" do
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