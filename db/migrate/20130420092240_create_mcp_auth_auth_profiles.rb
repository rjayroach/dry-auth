class CreateMcpAuthAuthProfiles < ActiveRecord::Migration
  def change
    create_table :mcp_auth_auth_profiles do |t|
      t.references :user
      t.string :provider
      t.string :uid
#      t.string :name
#      t.string :image
#      t.string :gender
#      t.string :email
#      t.date :birthdate
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
    add_index :mcp_auth_auth_profiles, :user_id
  end
end
