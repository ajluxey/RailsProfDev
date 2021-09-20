feature 'User can rate question', %q(
  In order to show helpfull/useless of question
  As an authenticated user
  I'd like to be able to rate question
) do
  given!(:question) { create(:question) }
  given(:user)      { create(:user)     }

  scenario 'Unatuhenticated user tries to rate question' do
    visit question_path(question)

    within('.question') do
      expect(page).not_to have_content('+')
      expect(page).not_to have_content('-')
    end
  end

  describe 'Authenticated user', js: true do
    background do
      login_as(user)
      visit question_path(question)
    end

    describe 'author of question' do
      given(:question) { create(:question, author: user) }

      scenario 'tries to rate his question' do
        within('.question') do
          expect(page).not_to have_content('+')
          expect(page).not_to have_content('-')
        end
      end
    end

    scenario 'tries to rate question' do
      within('.question') do
        expect(page).to have_content '0'

        click_on '+'

        expect(page).to have_content '1'
      end
    end

    describe 'already rates this question' do
      background do
        within('.question') do
          click_on '+'
        end
      end

      scenario 'tries to rate again' do
        within('.question') do
          expect(page).to have_content '1'
          expect(page).not_to have_content '+'
          expect(page).not_to have_content '-'
        end
      end

      scenario 'tries to cancel his rate' do
        within('.question') do
          expect(page).to have_content '1'

          click_on 'Cancel rating'

          expect(page).to have_content '0'
        end
      end

      scenario 'tries to rerate by another value' do
        within('.question') do
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
