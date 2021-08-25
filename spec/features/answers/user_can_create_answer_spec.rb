feature 'User can create answer', %q(
  In order to get answer for question
  As an author of question
  I'd like to be able to add the answer
) do
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to create answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Create new answer'
  end

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }

    background do
      login_as(user)
      visit question_path(question)
    end

    scenario 'creates an answer' do
      fill_in 'Body', with: 'Answer title'
      click_on 'Create new answer'

      expect(page).to have_content 'Your answer successfully created.'
    end

    scenario 'creates an answer with errors' do
      click_on 'Create new answer'

      expect(page).to have_content "Body can't be blank"
    end
  end
end
