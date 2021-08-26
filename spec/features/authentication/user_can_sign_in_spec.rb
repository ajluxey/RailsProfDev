feature 'User can sign in', %q(
  In order to ask questions
  As an unauthorized user
  I'd like to be able to sign in
) do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'user@mail.ru'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'Authenticated user tries to sign in' do
    login_as(user)
    visit new_user_session_path

    expect(page).to have_content 'You are already signed in.'
  end
end
