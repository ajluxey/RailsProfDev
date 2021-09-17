feature 'User can add files', %q(
  In order to answered on question with files
  As an authenticated user
  I'd like to be able to answer on question with files
) do
  given(:question) { create(:question) }
  given(:user)     { create(:user)     }

  background { login_as(user) }

  scenario 'User can creates answer with files', js: true do
    visit question_path(question)

    fill_in 'Body', with: 'Answer title'

    attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create new answer'

    expect(page).to have_link 'rails_helper.rb'
  end


  describe 'User can update answer', js: true do
    given!(:answer) { create(:answer, question: question, author: user) }

    background do
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'by adding file' do
      within('.answers') do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Update'

        expect(page).to have_link 'rails_helper.rb'
      end
    end

    context 'with files' do
      given!(:answer) { create(:answer_with_file, question: question, author: user) }

      scenario 'by adding file' do
        within('.answers') do
          attach_file 'Files', "#{Rails.root}/spec/spec_helper.rb"
          click_on 'Update'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'by deleting file' do
        # check "answers_files_blob_ids_#{answer.files.first.id}"
        click_on 'Update'

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end
  end
end
