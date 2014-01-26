require 'spec_helper'


module DryAuth

  # 
  # The User API allows a user with role :api to log in with a token in HTTP header or as a URL param
  #
  describe "users API spec" do
    before(:each) do
      @api_user = create(:dry_auth_user, :as_api)
      expect(@api_user.authentication_token).to_not be_nil
    end


    describe "param token" do
      context "valid" do
        after(:each) do
          expect(response.status).to eq(200)
          expect(response.body).to eq({authentication_token: "#{@api_user.authentication_token}"}.to_json)
        end
        it "#show via profile path" do
          get api_profile_url, {auth_token: "#{@api_user.authentication_token}"}, format: :json
        end
        it "#show via show path" do
          get api_user_url(@api_user), {auth_token: "#{@api_user.authentication_token}"}, format: :json
        end
      end

      context "invalid" do
        after(:each) do
          expect(response.status).to eq(401)
        end
        it "#show via profile path" do
          get api_profile_url, {auth_token: "x#{@api_user.authentication_token}"}, format: :json
        end
        it "#show via show path" do
          get api_user_url(@api_user), {auth_token: "x#{@api_user.authentication_token}"}, format: :json
        end
      end

    end


    describe "HTTP header token" do
      context "valid" do
        after(:each) do
          expect(response.status).to eq(200)
          expect(response.body).to eq({authentication_token: "#{@api_user.authentication_token}"}.to_json)
        end
        it "#show via profile path" do
          get api_profile_url, {}, {"HTTP_X_API_KEY" => "#{@api_user.authentication_token}"}
        end
        it "#show via show path" do
          get api_user_url(@api_user), {}, {"HTTP_X_API_KEY" => "#{@api_user.authentication_token}"}
        end
      end #valid

      context "invalid" do
        after(:each) do
          expect(response.status).to eq(401)
        end
        it "#show via profile path" do
          get api_profile_url, {}, {"HTTP_X_API_KEY" => "x#{@api_user.authentication_token}"}
        end
        it "#show via show path" do
          get api_user_url(@api_user), {}, {"HTTP_X_API_KEY" => "x#{@api_user.authentication_token}"}
        end
      end # invalid

      context "missing" do
        after(:each) do
          expect(response.status).to eq(401)
        end
        it "#show via profile path" do
          get api_profile_url
        end
        it "#show via show path" do
          get api_user_url(@api_user)
        end
      end # 
    end # HTTP header token 

  end
end


