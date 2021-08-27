feature 'User can delete answer', %q(
  In order to delete answer for question
  As an author of question
  I'd like to be able to delete the answer
) do
  given!(:answer) { create(:answer) }

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(answer.question)

    expect(page).not_to have_content 'Delete answer'
  end

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login_as(user)

      visit question_path(answer.question)
    end

    scenario 'is not author tries to delete answer' do
      expect(page).not_to have_content 'Delete answer'
    end

    describe 'is author' do
      given!(:answer) { create(:answer, author: user) }

      scenario 'tries to delete answer' do
        within '.answers' do
          expect(page).to have_content answer.body

          click_on 'Delete answer'

          expect(page).not_to have_content answer.body
        end

        expect(page).to have_content 'Your answer successfully deleted.'
      end
    end
  end
end
