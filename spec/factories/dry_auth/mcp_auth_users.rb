# Read about factories at https://github.com/thoughtbot/factory_girl

module DryAuth
  FactoryGirl.define do

    factory :dry_auth_user, class: User do
      username { Faker::Name.first_name }
      password 'abcd1234'
      locale 'en'
      email { Faker::Internet.email }

      trait :as_admin do
        before(:create) do |instance, evaluator|
          instance.add_role :admin
        end
      end

      trait :as_api do
        email 'api-test-user@test.com'
        password '12345678'
        before(:create) do |instance, evaluator|
          instance.add_role :api
        end
      end

      trait :with_dave_tone_facebook do
        after(:create) do |instance, evaluator|
          instance.auth_profiles << create(:dry_auth_auth_profile, :dave_tone_facebook,
                                          user: instance)
        end
      end

      trait :with_facebook do
        after(:create) do |instance, evaluator|
          instance.auth_profiles << create(:dry_auth_auth_profile, user: instance)
        end
      end
    end

  end
end


