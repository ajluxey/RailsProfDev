feature 'User can add comment to question', %q(
  In order to complete complete
  As an authenticated user
  I'd like to be able to add comment
) do
  given!(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'Unauthenticated user tries to add comment to question' do
    expect(page).not_to have_content 'New comment'
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login_as(user)
      visit question_path(question)
    end

    describe 'tries to create comment' do
      scenario 'with valid params' do
        Capybara.using_session('guest') do
          visit question_path(question)
        end

        within('.comments') do
          fill_in 'New comment', with: 'CreatedComment'
          click_on 'Create Comment'

          expect(page).to have_content 'CreatedComment'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'CreatedComment'
        end
      end

      scenario 'with invalid params' do
        within('.comments') do
          click_on 'Create Comment'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end
end
