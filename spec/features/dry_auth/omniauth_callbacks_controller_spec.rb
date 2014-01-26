require 'spec_helper'

# Feature test; uses capybara to run integration tests

=begin
include Warden::Test::Helpers
Warden.test_mode!

Then you can make a call to the warden helper login_as with a user resource and specifying the :scope => :user to 'log in' a test user.

user = Factory.create(:user)
login_as(user, :scope => :user)

To make sure this works correctly you will need to reset warden after each test you can do this by calling

Warden.test_reset! 

If for some reason you need to log out a logged in test user, you can use Warden's logout helper.

logout(:user)
=end

module DryAuth
  describe OmniauthCallbacksController do

=begin
    # add test in common: should be able to visit root of application and get to common/home
    # add test in auth: visit home as no user and get to common/home
    # another test: visit to dashboard should fail without login
    context "non authenticated user" do
      it "can view home page" do
        visit '/'
        expect(page).to have_content('hello from Home!!!')
      end

      it "cannot view other pages (dashboard)" do
        visit users_path
        # expect a redirect
        expect(page).to have_content('Log in')
      end

      # Failing because of redirects
      # Todo: implmenet redirect_to dashboard on login
      xit "can authenticate" do
        user = create(:dry_auth_user)
        visit users_path
        expect(page).to have_content('Log in')
        fill_in('user_login', with: user.email)
        fill_in('user_password', with: 'abcd1234')
        click_button('Log in')
        expect(page).to have_content('Signed in successfully.')
      end
    end



    context "authenticated user" do
      # See: https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
      before(:each) do
        Warden.test_mode!
        @admin = create(:dry_auth_user, :as_admin)
        @user = create(:dry_auth_user)
        @api_user = create(:dry_auth_user, :as_api)
      end

      after(:each) do
        Warden.test_reset!
      end

      context "api_user" do
        before(:each) do
          login_as(@api_user, :scope => :user)
          expect(@api_user.has_role? :api).to be_true
        end
        describe "manage profile" do
          it "shows the authentication token" do
            visit profile_path
            expect(page).to have_content(@api_user.email)
            expect(page).to have_content(@api_user.authentication_token)
          end
        end
      end

      context "admin" do
        before(:each) do
          login_as(@admin, :scope => :user)
          expect(@admin.has_role? :admin).to be_true
        end

        describe "manage users" do
          it "lists all users" do
            visit users_path
            expect(page).to have_content('Users')
            expect(page).to have_content(@admin.email)
            expect(page).to have_content(@user.email)
          end
          # todo add CRUD of users
        end

        describe "manage profile" do
          it "shows the current user profile" do
            visit profile_path
            expect(page).to have_content(@admin.email)
            expect(page).to_not have_content(@user.email)
          end
        end
      end # admin


      context "not admin" do
        before(:each) do
          login_as(@user, :scope => :user)
          expect(@user.has_role? :admin).to be_false
        end

        # todo: this is not working in tests, though it works with visual test of website
        describe "manage users" do
          xit "redirects to dashboard" do
            visit users_path
            expect(page).to have_content('hello from Home!!!')
          end
        end
      end # not admin
    end # authenticated user
=end
  end
end

