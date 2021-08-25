feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    login_as(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit root_path

    expect(page).not_to have_content 'Log out'
  end
end
