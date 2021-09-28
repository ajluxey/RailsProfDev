RSpec.describe DailyDigestJob, type: :job do
  it 'calls NotificationService::send_daily_digest' do
    expect(NotificationService).to receive(:send_daily_digest)
    DailyDigestJob.perform_now
  end
end
