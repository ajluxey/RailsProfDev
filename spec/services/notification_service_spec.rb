RSpec.describe NotificationService do
  let(:users)     { create_list(:user, 5) }
  let(:questions) { create_list(:question, 5) }

  describe '::send_daily_digest' do
    it 'sends daily digest to all users' do
      User.all.each { |user| expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original }
      NotificationService.send_daily_digest
    end
  end

  describe '::notified_about_new_answer' do
    let(:question)    { create(:question) }
    let(:answer)      { create(:answer, question: question) }
    let(:subscribers) { users[0..2] }

    before do
      subscribers.each { |subscriber| create(:subscription, user: subscriber, question: question) }
    end

    it 'send notification with answer to question subscribers' do
      subscribers.each { |user| expect(NotificationMailer).to receive(:new_answer).with(user, answer).and_call_original }
      NotificationService.notify_about_new_answer(answer)
    end
  end
end
