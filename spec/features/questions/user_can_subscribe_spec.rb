feature 'User can subscribe on question', %q(
  In order to know that someone
  add new answer to question
  as authenticated user I'd like
  to be able to subscribe on question
) do
  given(:user)      { create(:user)     }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to subscribe on question' do
    visit question_path(question)

    expect(page).not_to have_button 'Subscribe'
  end

  describe 'Authenticated', js: true do
    background do
      login_as(user)
      visit question_path(question)
    end

    scenario 'unsubscribed user tries to subscribe on question' do
      click_on 'Subscribe'

      expect(page).to have_content 'You are subscribed'
      expect(page).to have_button 'Unsubscribe'
      expect(page).not_to have_button 'Subscribe'
    end

    context 'subscribed user' do
      given!(:subscription) { create(:subscription, user: user, question: question) }

      scenario 'tries to unsubscribes' do
        click_on 'Unsubscribe'

        expect(page).to have_content 'You are unsubscribed'
        expect(page).to have_button 'Subscribe'
        expect(page).not_to have_button 'Unsubscribe'
      end
    end
  end
end
