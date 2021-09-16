feature 'User can add files', %q(
  In order to get question with files for community
  As an authenticated user
  I'd like to be able to ask the question with files
) do

  given(:user) { create(:user) }

  describe 'User creates a question', js: true do
    background do
      login_as(user)

      visit new_question_path

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
    end

    scenario 'with attached file' do
      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'with attached files' do
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'User updates the question', js: true do
    given(:question) { create(:question, author: user) }

    background do
      login_as(user)

      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'by attaching file' do
      within('.question') do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Update'

        expect(page).to have_link 'rails_helper.rb'
      end
    end

    context 'with file' do
      given(:question) { create(:question_with_file, author: user) }

      scenario 'by attaching file' do
        within('.question') do
          attach_file 'Files', "#{Rails.root}/spec/spec_helper.rb"
          click_on 'Update'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'by deleting file' do
        check "question_files_blob_ids_#{question.files.first.id}"
        click_on 'Update'

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end
  end
end
