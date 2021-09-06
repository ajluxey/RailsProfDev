feature 'User can update question', %q(
  In order to correct mistakes in question
  As authenticated author of question
  I'd like to be able to edit question
) do
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user tries to update question' do
    visit question_path(question)

    expect(page).not_to have_content 'Edit'
  end

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login_as(user)
      visit question_path(question)
    end

    scenario 'is not author tries to update question' do
      expect(page).not_to have_link 'Edit'
    end

    describe 'is author tries to update question' do
      given!(:question) { create(:question, author: user) }

      background { click_on 'Edit' }

      scenario 'with valid params' do
        within('.question') do
          fill_in 'Title', with: 'NewTitle'
          fill_in 'Body', with: 'NewBody'
          click_on 'Update'

          expect(page).to have_content 'NewTitle'
          expect(page).to have_content 'NewBody'
          expect(page).not_to have_content question.body
          expect(page).not_to have_selector 'textarea'
        end

        expect(page).to have_content 'Your question successfully updated.'
      end

      scenario 'with invalid params' do
        within('.question') do
          fill_in 'Title', with: ''
          click_on 'Update'

          expect(page).to have_content question.title
        end

        expect(page).to have_content "Title can't be blank"
      end

      scenario 'by adding files' do
        within('.question') do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Update'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      describe 'with files' do
        given!(:question) { create(:question_with_file, author: user) }

        scenario 'by adding file' do
          within('.question') do
            attach_file 'Files', "#{Rails.root}/spec/spec_helper.rb"
            click_on 'Update'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end

        scenario 'by deleting files' do
          within('.question') do
            check "question_files_blob_ids_#{question.files.first.id}"
            click_on 'Update'

            expect(page).not_to have_link 'rails_helper.rb'
          end
        end
      end
    end
  end
end

