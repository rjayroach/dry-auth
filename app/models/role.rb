class Role < ActiveRecord::Base
  has_and_belongs_to_many :dry_auth_users, join_table: :dry_auth_users_roles, association_foreign_key: 'user_id'
  belongs_to :resource, polymorphic: true
  
  scopify
end
