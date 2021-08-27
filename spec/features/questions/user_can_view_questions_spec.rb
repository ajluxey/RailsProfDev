feature 'User can view questions', %q(
  As an unauthenticated user
  I'd like to be able to see
  all questions or some question
) do
  given(:count) { 5 }
  given!(:questions) { create_list(:question, count) }
  given!(:answers) { create_list(:answer, count, question: questions.first) }

  background { visit questions_path }

  scenario 'Any user tries see all questions' do
    visit questions_path

    expect(page.find(:table)).to have_content(questions.first.body).exactly(count).times
  end

  scenario 'Any user tries to see the specific question' do
    page.all('tr')[0].click_on 'Show'

    expect(page).to have_current_path(question_path(questions.first))
  end
end
