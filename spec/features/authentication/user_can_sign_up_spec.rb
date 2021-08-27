feature 'User can sign up', %q(
  In order to get permissions
  As an authenticated user
  I'd like to be able to sign up
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign up' do
    login_as(user)

    visit new_user_registration_path

    expect(page).to have_content 'You are already signed in.'
  end

  describe 'Unauthenticated' do
    background do
      visit new_user_registration_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'
    end

    scenario 'registered user tries to sign up again' do
      expect(page).to have_content 'Email has already been taken'
    end

    describe 'unregistered user tries to sign up' do
      context 'with valid authentication data' do
        given(:user) { build(:user) }

        scenario 'successfully' do
          expect(page).to have_content 'Welcome! You have signed up successfully.'
        end
      end

      context 'with invalid authetication data' do
        given(:user) { build(:user, :invalid) }

        scenario 'unsuccessfully' do
          expect(page).to have_content 'Email is invalid'
        end
      end
    end
  end
end
