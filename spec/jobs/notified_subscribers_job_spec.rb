RSpec.describe NotifiedSubscribersJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls NotificationService::send_daily_digest' do
    expect(NotificationService).to receive(:notify_about_new_answer).with(answer)
    NotifiedSubscribersJob.perform_now(answer)
  end
end
