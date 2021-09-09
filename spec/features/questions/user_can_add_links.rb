feature 'User can add links to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user)     { create(:user) }
  given(:gist_url) { 'https://gist.github.com/GrahamcOfBorg/40a2b16da442869374c0ada06535b9b8' }

  scenario 'User add links when he creates question' do
    login_as(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'

    # click_on 'Add Link'
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Create Question'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User add links when he creates question with errors' do
    login_as(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'

    # click_on 'Add Link'
    click_on 'Create Question'

    expect(page).to have_content "Name can't be blank"
  end
end
