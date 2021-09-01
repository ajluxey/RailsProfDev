feature 'User can delete question', %q(
  In order to delete question from site
  As an author of question
  I'd like to be able to delete the answer
) do
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to delete question' do
    visit questions_path
    click_on 'Show'

    expect(page).not_to have_content 'Delete question'
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login_as(user)

      visit questions_path
      click_on 'Show'
    end

    scenario 'is not author tries to delete question' do
      expect(page).not_to have_content 'Delete question'
    end

    describe 'is author' do
      given!(:question) { create(:question, author: user) }

      scenario 'tries to delete question' do
        expect(page).to have_content question.title

        click_on 'Delete question'

        expect(page).to have_content 'Your question successfully deleted.'
        expect(page).not_to have_content question.title
      end
    end
  end
end
