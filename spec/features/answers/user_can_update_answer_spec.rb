feature 'user can update answer', %q(
  In order to correct mistakes in answer
  As authenticated user-author
  I'd like to be able update answer
) do
  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }

  scenario 'Unauthenticated user can not update answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login_as(user)
      visit question_path(question)
    end

    describe 'author tries to update answer' do
      given!(:answer) { create(:answer, question: question, author: user) }

      background { click_on 'Edit' }

      scenario 'with valid params' do
        fill_in 'Body', with: 'NewBody'
        click_on 'Update'

        expect(page).to have_content 'Your answer successfully updated.'
        expect(page).to have_content 'NewBody'
      end

      scenario 'with invalid params' do
        click_on 'Update'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'not author tries to update answer' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
