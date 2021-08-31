feature 'User can choose best answer', %q(
  In order to higlight best answer
  As authenticated user - question author
  I'd like to be able to choose this answer as best
) do
  given(:question)   { create(:question)                           }
  given!(:answers)   { create_list(:answer, 3, question: question) }

  scenario 'Unauthenticated user tries to choose best answer' do
    visit question_path(question)

    expect(page).not_to have_button('Highlight as best answer')
  end

  describe 'Authenticated user' do
    given(:user)     { create(:user)     }
    given(:question) { create(:question) }

    background do
      login_as(user)
      visit question_path(question)
    end

    describe 'author of question', js: true do
      given(:question) { create(:question, author: user) }

      scenario 'highlighted answer as best' do
        future_best_answer = page.all('div[data-answer-id]')[-1]

        within(future_best_answer) do
          expect(page).not_to have_content 'Best answer'

          click_on 'Highlight as best answer'
        end

        expect(future_best_answer).to have_content 'Best answer'
      end
    end

    scenario 'not author of question answer tries to choose best answer' do
      expect(page).not_to have_content 'Best answer'
    end
  end
end
