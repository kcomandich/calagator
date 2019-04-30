require 'rails_helper'

feature 'import events from a feed', js: true do
  background do
    Timecop.travel('2010-01-01')
    stub_request(:get, 'http://even.ts/feed').to_return(body: read_sample('ical_multiple_calendars.ics'))
  end

  after do
    Timecop.return
  end

  scenario 'A user imports an events from a feed' do
    visit '/'
    click_on 'Import events'

    fill_in 'URL', with: 'http://even.ts/feed'
    click_on 'Import'

    expect(find('.flash')).to have_content "Imported 3 entries:\nCoffee with Jason\nCoffee with Mike\nCoffee with Kim"

    expect(page).to have_content 'Viewing 3 future events'

    expect(find('.event_table')).to have_content "\nThursday\nApr 8 Coffee with Jason\n7–8am\nCoffee with Mike\n7–8am\nCoffee with Kim\n7–8am"
  end
end
