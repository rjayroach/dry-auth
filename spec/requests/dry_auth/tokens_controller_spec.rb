require 'spec_helper'


module DryAuth

  # 
  # The User API allows a user with role :api to log in with standard credentials
  #   and returns a token which can be used for automated login in future requests
  #
  # TODO test the other results such as invalid request, params, etc
  #
  describe "users API spec" do
    before(:each) do
      @user = create(:dry_auth_user, :as_api)
      expect(@user.authentication_token).to_not be_nil
    end

    # See: http://matteomelani.wordpress.com/2011/10/17/authentication-for-mobile-devices/
    describe "returns a token when an api user logs in with JSON" do
      after(:each) do
        expect(response.status).to eq(200) # "Created"
        expect(response.body).to eq({token: "#{@user.authentication_token}"}.to_json)
      end

      it "accepts email address" do
        post api_tokens_url, login: "#{@user.email}", password: "#{@user.password}", format: "json"
      end
      it "accepts username" do
        post api_tokens_url, login: "#{@user.username}", password: "#{@user.password}", format: "json"
      end
    end

    describe "#destroy" do
      it "resets the token when destroy" do
        delete api_token_url( "#{@user.authentication_token}" )
        expect(response.status).to eq(200) # Reset
      end
      it "does not reset when invalid token is sent" do
        delete api_token_url( "abcdedf12345" )
        expect(response.status).to eq(404) # Reset
      end
    end

  end
end


