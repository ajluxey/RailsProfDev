feature 'User can add links to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user)      { create(:user)       }
  given(:new_link)  { build(:link, :new)  }
  given(:gist_link) { build(:link, :gist) }

  background { login_as(user) }

  describe 'User create question', js: true do
    background do
      visit new_question_path

      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Body'

      click_on 'Add link'

      fill_in 'Link name', with: new_link.name
    end


    scenario 'with adding link' do
      fill_in 'URL', with: new_link.url

      click_on 'Create Question'

      expect(page).to have_link new_link.name, href: new_link.url
    end

    scenario 'with adding gist link' do
      fill_in 'URL', with: gist_link.url

      click_on 'Create Question'

      expect(page).to have_content "puts 'test'"
    end

    scenario 'with adding invalid link' do
      click_on 'Create Question'

      expect(page).to have_content "Links url can't be blank"
    end
  end

  describe 'User update question', js: true do
    given(:question) { create(:question, author: user) }

    background do
      visit question_path(question)

      click_on 'Edit'
    end

    describe 'by adding link' do
      background do
        within('.question') do
          click_on 'Add link'

          fill_in 'URL', with: new_link.url
        end
      end

      scenario 'with valid params' do
        fill_in 'Link name', with: new_link.name

        click_on 'Update Question'

        expect(page).to have_link new_link.name, href: new_link.url
      end

      scenario 'with invalid params' do
        click_on 'Update Question'

        expect(page).to have_content "Links name can't be blank"
      end
    end
  end

  describe 'User update the question with link', js: true do
    given(:question) { create(:question, author: user)   }
    given!(:link)    { create(:link, linkable: question) }

    background do
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'by adding another link' do
      within('.question') do
        click_on 'Add link'

        link_form = page.all('.nested-fields').last

        within(link_form) do
          fill_in 'Link name', with: new_link.name
          fill_in 'URL', with: new_link.url
        end

        click_on 'Update Question'

        expect(page).to have_link new_link.name, href: new_link.url
        expect(page).to have_link link.name, href: link.url
      end
    end

    scenario 'by deleting link' do
      click_on 'Remove link'
      click_on 'Update Question'

      expect(page).not_to have_link link.name, href: link.url
    end
  end
end
