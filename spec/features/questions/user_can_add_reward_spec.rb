feature 'User can add reward to question', %q(
  In order to reward user for answering
  As an question's author
  I'd like to be able to add reward on creating question
) do
  given(:user) { create(:user) }

  background do
    login_as(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
  end

  scenario 'User adds reward when creating question', js: true do
    within('#reward') do
      fill_in 'Name', with: 'Reward'
      attach_file 'Image', "#{Rails.root}/tmp/test_images/congrats.jpg"
    end

    click_on 'Create Question'

    expect(page).to have_content 'You can get reward for best answer on this question'
  end

  scenario 'User adds reward with errors when creating question', js: true do
    within('#reward') do
      attach_file 'Image', "#{Rails.root}/tmp/test_images/congrats.jpg"
    end

    click_on 'Create Question'

    expect(page).to have_content "Reward name can't be blank"
  end
end
