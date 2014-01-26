# Read about factories at https://github.com/thoughtbot/factory_girl

module DryAuth
  FactoryGirl.define do
    factory :dry_auth_auth_profile, class: AuthProfile do
      association :user, factory: :dry_auth_user
=begin
      # TODO refactor, b/c a profile is not valid w/out a user
      # however, right now, just declaring the association creates two users
      # when creating a FanClub::Member
      trait :with_user do
        association :user, factory: :dry_auth_user
      end
=end

      trait :dave_tone_facebook do
        provider "facebook"
        uid '100005787840155'
        oauth_token "BAAIGIKlVC74BAK2epvRT9Sea4t05ZAZA6zSeAi4o3kLAdgkjENyuPtqguVONEZBwm0ffrzC7w1zaUlrBtDNWryKcYL5LyZBtvmQWX5wfLoxVagkp9B1LkDZB255LEb4r0eFWZCGZAtoAh60V5iChMtv3Q9N5zI3GwVyDeK2gZCmC6n30tfhgyFjJUQCPlgRTk3W1Xt2p4CRHlWzPlQygEXzD2WEimAO0eTyieSmAGIOZADQZDZD"
        oauth_expires_at "2013-07-07 04:13:47"
      end # :dave_tone

    end

  end
end


