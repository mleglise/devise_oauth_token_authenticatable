require 'spec_helper'

describe ProtectedController do

  describe 'get :index' do
    before do
      @token = '1234'
      stub_request(:get, "http://oauth-test.com/api/getUserInfoByAccessToken?access_token=#{@token}&client_id=this-is-a-client-id").
        to_return(
          body: lambda {|request| "{\"access_token\":\"#{@token}\",\"token_type\":\"bearer\"}" },
          # body: lambda {|request| "{\"access_token\":\"#{@token}\",\"token_type\":\"bearer\",\"email\":\"#{user.email}\"}" },
          headers: { "content-type"=>"application/json; charset=UTF-8" },
          status: 200
        )
      
      stub_request(:get, "http://oauth-test.com/api/getUserInfoByAccessToken?access_token=invalid&client_id=this-is-a-client-id").
        to_return(:status => 200, :body => "", :headers => {})
    end

    context 'with valid bearer token in header' do
      before do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
        get :index, :format => 'json'
      end
      it { should respond_with :ok }
    end

    context 'with valid bearer token in query string' do
      before do
        get :index, :access_token => @token, :format => 'json'
      end
      it { should respond_with :ok }
    end

    context 'with invalid bearer token in query param' do
      before do
        get :index, :access_token => 'invalid', :format => 'json'
      end
      it { should respond_with :unauthorized }
    end

    context 'with valid bearer token in header and query string' do
      before do
      end
      it 'raises error' do
        lambda {
          @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
          get :index, :access_token => @token, :format => 'json'
        }.should raise_error
      end
    end

    context 'with no token anywhere' do
      before do
        get :index, :format => 'json'
      end
      it { should respond_with :unauthorized }
    end

  end
end
