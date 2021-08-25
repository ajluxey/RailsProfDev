feature 'User can view answers for question', %q(
  As an unauthenticated user
  I'd like to be able to see
  answers for some question
) do
  given(:answers_count) { 5 }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, answers_count, question: question) }

  scenario 'Any user tries to see answers for question' do
    visit questions_path
    click_on 'Show'

    expect(page).to have_current_path(question_path(question))
    expect(page.find(:table)).to have_content(answers.first.body).exactly(answers_count).times
  end
end
