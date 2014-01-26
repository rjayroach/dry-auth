
user = McpAuth::User.create! username: 'admin', email: 'admin@example.com', password: 'admin123', time_zone: 'Singapore'
user.add_role :admin

