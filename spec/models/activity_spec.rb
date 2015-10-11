RSpec.describe 'Activity' do
  it 'will return all dates, listed once, in chronological order' do
    Activity.create! [
      {activity_type: :daily_fact, date: '2000-10-05'},
      {activity_type: :daily_fact, date: '2001-01-01'},
      {activity_type: :daily_fact, date: '2000-01-01'},
      {activity_type: :daily_fact, date: '2000-01-01'},
    ]
    expect(Activity.all_dates).to eq [
      Date.parse('2000-01-01'),
      Date.parse('2000-10-05'),
      Date.parse('2001-01-01'),
    ]
  end
end
