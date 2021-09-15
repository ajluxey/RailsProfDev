feature 'User can add links to answer', %q(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
) do
  given(:user)     { create(:user)      }
  given(:question) { create(:question)  }
  given(:new_link) { build(:link, :new) }

  background do
    login_as(user)
  end

  describe 'User create answer', js: true do
    background do
      visit question_path(question)

      fill_in 'Body', with: 'Body'

      click_on 'Add link'

      fill_in 'Link name', with: new_link.name
    end

    scenario 'with adding link' do
      fill_in 'URL', with: new_link.url

      click_on 'Create new answer'

      expect(page).to have_link new_link.name, href: new_link.url
    end

    scenario 'with adding gist link' do
      # fill_in 'URL', with: url
      #
      # click_on 'Create new answer'
      #
      # expect(page).to have_content "puts 'test'"
    end

    scenario 'with adding invalid link' do
      click_on 'Create new answer'

      expect(page).to have_content "Links url can't be blank"
    end
  end

  describe 'User update answer', js: true do
    given!(:answer) { create(:answer, question: question, author: user) }

    background do
      visit question_path(question)

      click_on 'Edit'
    end

    describe 'by adding link' do
      background do
        page.find('.answers').click_on 'Add link'

        fill_in 'URL', with: new_link.url
      end

      scenario 'with valid params' do
        fill_in 'Link name', with: new_link.name

        click_on 'Update'

        expect(page).to have_link new_link.name, href: new_link.url
      end

      scenario 'with invalid params' do
        click_on 'Update'

        expect(page).to have_content "Links name can't be blank"
      end
    end
  end

  describe 'User update an answer with link', js: true do
    given!(:answer) { create(:answer, question: question, author: user) }
    given!(:link)   { create(:link, linkable: answer)                   }

    background do
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'by adding another link' do
      within('.answers') do
        click_on 'Add link'

        link_form = page.all('.nested-fields').last

        within(link_form) do
          fill_in 'Link name', with: new_link.name
          fill_in 'URL', with: new_link.url
        end

        click_on 'Update'

        expect(page).to have_link link.name, href: link.url
        expect(page).to have_link new_link.name #, href: new_link.url # Почему-то ссылка вставляется как https:github.com, без двух слешей
      end
    end

    scenario 'by deleting link' do
      click_on 'Remove link'
      click_on 'Update'

      expect(page).not_to have_link link.name, href: link.url
    end
  end
end
