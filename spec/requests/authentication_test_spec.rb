require 'rails_helper'

RSpec.describe "User Auth Requests", type: :request do
  before(:each) do
    @current_user = FactoryBot.create(:user)

  end
  describe 'signed in' do
    let(:user) {FactoryBot.create(:user)}
    sign_in(:user)

    it 'should respond with success' do
      get '/api/v1/auth/validate_token' # yes, nothing changed here
      expect(response).to have_http_status(:success)
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get '/api/v1/auth/validate_token'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'get Notes without token' do
    it 'should respond with unauthorized' do
      get '/api/v1/notes'
      expect(response).to have_http_status(:unauthorized)
    end
  end
  describe 'get Notes with token' do
    # let(:user) {FactoryBot.create(:user)}
    # sign_in(:user)
    it 'should respond with ok' do
      login
      auth_params = get_auth_params_from_login_response_headers(response)
      get '/api/v1/notes', headers: auth_params
      expect(response).to have_http_status(:success)
    end
  end

  def login
     post '/api/v1/auth/sign_in', params:  { email: @current_user.email, password: "password"}.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

   def get_auth_params_from_login_response_headers(response)
     client = response.headers['client']
       token = response.headers['access-token']
       expiry = response.headers['expiry']
       token_type = response.headers['token-type']
       uid =   response.headers['uid']

       auth_params = {
                       'access-token' => token,
                       'client' => client,
                       'uid' => uid,
                       'expiry' => expiry,
                       'token_type' => token_type
                     }
       auth_params
   end
end
