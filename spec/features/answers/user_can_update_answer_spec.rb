feature 'user can update answer', %q(
  In order to correct mistakes in answer
  As authenticated user-author
  I'd like to be able update answer
) do
  given!(:question) { create(:question)                   }
  given!(:answer)   { create(:answer, question: question) }

  scenario 'Unauthenticated user can not update answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login_as(user)
      visit question_path(question)
    end

    describe 'author tries to update answer', js: true do
      given!(:answer) { create(:answer, question: question, author: user) }

      background { click_on 'Edit' }

      scenario 'with valid params' do
        within('.answers') do
          fill_in 'Body', with: 'NewBody'
          click_on 'Update'

          expect(page).to have_content 'NewBody'
          expect(page).not_to have_content answer.body
          expect(page).not_to have_selector 'textarea'
        end

        expect(page).to have_content 'Your answer successfully updated.'
      end

      scenario 'with invalid params' do
        within('.answers') do
          fill_in 'Body', with: ''
          click_on 'Update'

          expect(page).to have_content answer.body
        end

        expect(page).to have_content "Body can't be blank"
      end

      scenario 'by adding files' do
        within(%Q(div[data-answer-id="#{answer.id}"])) do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Update'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      describe 'with files' do
        given!(:answer) { create(:answer_with_file, author: user, question: question) }

        scenario 'by adding file' do
          within(%Q(div[data-answer-id="#{answer.id}"])) do
            attach_file 'Files', "#{Rails.root}/spec/spec_helper.rb"
            page.find("#answer_files_blob_ids_#{answer.files.first.id}").set(false)
            click_on 'Update'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end

        scenario 'by deleting files' do
          within(%Q(div[data-answer-id="#{answer.id}"])) do
            check "answer_files_blob_ids_#{answer.files.first.id}"
            click_on 'Update'

            expect(page).not_to have_link 'rails_helper.rb'
          end
        end
      end
    end

    scenario 'not author tries to update answer' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
