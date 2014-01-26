
module SessionHelpers
  # See: http://robots.thoughtbot.com/post/33771089985/rspec-integration-tests-with-capybara
  def log_in_with(login, password)
    visit dry_auth.new_user_session_path
    expect(page).to have_content('Log in')
    fill_in('user_login', with: login)
    fill_in('user_password', with: password)
    click_button('Log in')
  end
end


