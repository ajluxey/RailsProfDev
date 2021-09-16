feature 'User can view his rewards', %q(
  As an authenticated user
  I'd like to be able to see
  rewards for my best answers
) do
  given(:user) { create(:user) }

  scenario 'Unauthenticated user tries to see his rewards' do
    visit rewards_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authenticated user' do
    given!(:reward) { create(:reward) }

    background do
      login_as(user)
      visit rewards_path
    end

    describe 'which was awarded' do
      given!(:reward)   { create(:reward, respondent: user) }
      given!(:question) { create(:question, reward: reward) }

      scenario 'tries to see rewards' do
        expect(page).to have_content question.title
        expect(page).to have_content reward.name
        expect(page).to have_xpath("//img[@src = '#{url_for(reward.image)}']")
      end
    end

    scenario 'but he have not rewards' do
      expect(page).to have_content 'You have not rewards'
    end
  end
end

