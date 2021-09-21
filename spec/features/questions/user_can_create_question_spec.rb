feature 'User can create question', %q(
  In order to get question for community
  As an authenticated user
  I'd like to be able to ask the question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      login_as(user)

      visit questions_path
      click_on 'Create new question'
    end

    scenario 'creates a question' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
      click_on 'Create Question'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'creates a question with errors' do
      click_on 'Create Question'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('guest') do
        visit questions_path
      end

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
      click_on 'Create Question'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'

      Capybara.using_session('guest') do
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
      end
    end
  end


  scenario 'Unauthenticated user tries to create a question' do
    visit questions_path
    click_on 'Create new question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
