require 'spec_helper'

feature 'Verify Google Home Page' do
  before do
    @app.google_home.load
  end

  scenario 'C845 verify the Google home page' do
    expect(page).to have_content('Google')
  end

  scenario 'C847 verify the Google home page to fail' do
    expect(page).to have_content('Goo gle')
  end

end