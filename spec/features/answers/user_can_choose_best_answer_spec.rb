feature 'User can choose best answer', %q(
  In order to higlight best answer
  As authenticated user - question author
  I'd like to be able to choose this answer as best
) do
  given(:question)   { create(:question)                   }
  given!(:answer)    { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to choose best answer' do
    visit question_path(question)

    expect(page).not_to have_button 'Highlight as best answer'
  end

  describe 'Authenticated user' do
    given(:user)     { create(:user)     }
    given(:question) { create(:question) }

    background do
      login_as(user)
    end

    scenario 'not author of question answer tries to choose best answer' do
      visit question_path(question)

      expect(page).not_to have_button 'Highlight as best answer'
    end

    describe 'author of question', js: true do
      given(:question) { create(:question, author: user) }

      scenario 'highlights answer as best' do
        visit question_path(question)

        expect(page).not_to have_content 'Best answer'

        click_button 'Highlight as best answer'

        expect(page).to have_content 'Best answer'
      end

      context 'with another best answer' do
        given!(:best_answer) { create(:answer, body: 'BestBody', best: true, question: question) }

        scenario 'highlights new best answer and can see him at top of the list' do
          visit question_path(question)

          best_answer_path, future_best_answer_path = page.all('div[data-answer-id]').map(&:path)

          expect(page.find(:xpath, best_answer_path)).to have_content best_answer.body

          within(page.find(:xpath, future_best_answer_path)) do
            expect(page).not_to have_content 'Best answer'
            expect(page).to have_content answer.body

            click_button 'Highlight as best answer'
          end

          within(page.find(:xpath, best_answer_path)) do
            expect(page).to have_content 'Best answer'
            expect(page).to have_content answer.body
          end
        end

        scenario 'hilglights best answer and can see only one' do
          visit question_path(question)

          click_button 'Highlight as best answer'

          expect(page).to have_content('Best answer').once
        end
      end
    end
  end
end
