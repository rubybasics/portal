require 'rails_helper'

RSpec.describe 'Admin adds lesson to schedule', type: :feature do
  it 'adds a lesson to the schedule' do
    today_is '2015-08-10'
    im_an_admin!

    visit '/admin'
    expect(current_path).to eq admin_path

    click_link 'Today'
    expect(current_path).to eq '/admin/today/2015-08-10'

    click_link 'Add Activity'
    expect(current_path).to eq '/admin/today/2015-08-10/activities/new'

    fill_in 'Title', with: 'Ruby Object Model'
    fill_in 'Location', with: 'Room A'
    fill_in 'Instructor', with: 'Josh Cheek'
    fill_in 'Cohort', with: '1508'
    fill_in 'Start', with: '9:00'
    fill_in 'Finsih', with: '12.00'
    fill_in 'Content', with: 'Lets learn the **Object Model**'

    click_link 'Create Activity'

    expect(current_path).to eq '/admin/daily/2015-08-10'
    expect(page).to have_content '1508'
    expect(page).to have_content 'Ruby Object Model'
  end
end
