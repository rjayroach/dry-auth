class RenameTablesFromMcpAuthToDryAuth < ActiveRecord::Migration
  def change
    rename_table :mcp_auth_users_roles, :dry_auth_users_roles
    rename_table :mcp_auth_users, :dry_auth_users
    rename_table :mcp_auth_auth_profiles, :dry_auth_auth_profiles
  end

end
