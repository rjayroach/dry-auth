require 'spec_helper'

module DryAuth
  describe AuthProfile do

    subject { build(:dry_auth_auth_profile) }
    
    it "has a valid factory" do
      expect(create(:dry_auth_auth_profile)).to be_valid
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


    describe "Associations" do
      it "belongs to a User" do
        expect(subject).to belong_to(:user)
      end
    end

  end
end
