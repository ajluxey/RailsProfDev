feature 'User can rate answer', %q(
  In order to show helpfull/useless of answer
  As an authenticated user
  I'd like to be able to rate answer
) do
  given!(:question) { create(:question)                   }
  given!(:answer)   { create(:answer, question: question) }
  given(:user)      { create(:user)                       }

  scenario 'Unatuhenticated user tries to rate answer' do
    visit question_path(question)

    within('.answers') do
      expect(page).not_to have_content('+')
      expect(page).not_to have_content('-')
    end
  end

  describe 'Authenticated user', js: true do
    background do
      login_as(user)
      visit question_path(question)
    end

    describe 'author of answer' do
      given(:answer) { create(:answer, author: user, question: question) }

      scenario 'tries to rate his answer' do
        within('.answers') do
          expect(page).not_to have_content('+')
          expect(page).not_to have_content('-')
        end
      end
    end

    scenario 'tries to rate answer' do
      within('.answers') do
        expect(page).to have_content '0'

        click_on '+'

        expect(page).to have_content '1'
      end
    end

    describe 'already rates answer' do
      background do
        within('.answers') do
          click_on '+'
        end
      end

      scenario 'tries to rate again' do
        within('.answers') do
          expect(page).to have_content '1'
          expect(page).not_to have_content '+'
          expect(page).not_to have_content '-'
        end
      end

      scenario 'tries to cancel his rate' do
        within('.answers') do
          expect(page).to have_content '1'

          click_on 'Cancel rating'

          expect(page).to have_content '0'
        end
      end

      scenario 'tries to rerate by another value' do
        within('.answers') do
          expect(page).to have_content '1'

          click_on 'Cancel rating'

          expect(page).to have_content '0'

          click_on '-'

          expect(page).to have_content '-1'
        end
      end
    end
  end
end
