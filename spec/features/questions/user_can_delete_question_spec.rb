feature 'User can delete answer', %q(
  In order to delete answer for question
  As an author of question
  I'd like to be able to delete the answer
) do

  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to delete question' do
    visit questions_path

    expect(page).not_to have_content 'Delete question'
  end

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login_as(user)

      visit questions_path
    end

    scenario 'is not author tries to delete question' do
      expect(page).not_to have_content 'Delete question'
    end

    describe 'is author' do
      given!(:question) { create(:question, author: user) }

      scenario 'tries to delete question' do
        click_on 'Delete question'

        expect(page).to have_content 'Your question successfully deleted.'
      end
    end
  end
end

