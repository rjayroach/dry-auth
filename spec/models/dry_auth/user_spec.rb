require 'spec_helper'

module DryAuth
  describe User do

    subject { build(:dry_auth_user) }
    
    it "has a valid factory" do
      expect(create(:dry_auth_user)).to be_valid
    end

    describe "Validations" do
      %w().each do |attr|
        it "requires #{attr}" do
          subject.send("#{attr}=", nil)
          expect(subject).to_not be_valid
          expect(subject.errors[attr.to_sym].any?).to be_true
        end
      end
    end  # Validations

=begin
  context "user tests" do
    before(:each) do
      @user = create(:dry_auth_user)
      @api_user = create(:dry_auth_user, :as_api)
      @admin = create(:dry_auth_user, :as_admin)
    end
    describe "#find_by_login" do
      context "finds record with valid values" do
        it "by email" do
          expect(User.find_by_login(@user.email).encrypted_password).to eq(@user.encrypted_password)
        end
        it "user by username" do
          expect(User.find_by_login(@user.username).encrypted_password).to eq(@user.encrypted_password)
        end
      end
      context "returns nil for invalid values" do
        it "by email" do
          expect(User.find_by_login("x#{@user.email}")).to be_nil
        end
        it "user by username" do
          expect(User.find_by_login("x#{@user.username}")).to be_nil
        end
      end

    end

    describe "tokens" do
      it "only generates a token for an api user" do
        expect(@user.authentication_token).to be_nil
        expect(@admin.authentication_token).to be_nil
      end
      it "generates a token for an api user" do
        expect(@api_user.authentication_token).to_not be_nil
      end
      it "generates a new token when requested" do
        old_token = @api_user.authentication_token
        @api_user.reset_authentication_token!
        expect(@api_user.reload.authentication_token).to_not be_empty
        expect(@api_user.reload.authentication_token).to_not eq(old_token)
      end
    end

    describe "standard user" do
      it "does not have role :admin" do
        expect(@user.has_role? :admin).to be_false
      end

      it "can be destroyed" do
        expect(User.count).to eq(3)
        @user.destroy
        expect(User.count).to eq(2)
      end
    end

    describe "admin user" do
      it "has role :admin" do
        expect(@admin.has_role? :admin).to be_true
      end

      # Admin must be downgraded to a normal user and then removed
      it "cannot be destroyed" do
        expect(User.count).to eq(3)
        @admin.destroy
        expect(User.count).to eq(3)
      end
    end

    describe "#from_omniauth" do
      it "creates a new profile" do
        expect(AuthProfile.count).to eq(0)
        y = YAML.load_file('spec/fixtures/auth_profile.yaml')
        User.from_omniauth(y)
        expect(AuthProfile.count).to eq(1)
        p = AuthProfile.first
        expect(p.provider).to eq('facebook')
        User.from_omniauth(y)
        expect(AuthProfile.count).to eq(1)
      end
    end
  end
=end
  end
end


