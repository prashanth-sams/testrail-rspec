require 'spec_helper'

feature 'Verify Google Home Page' do
  before do
    @app.google_home.load
  end

  scenario 'verify the Google home page', :ae do
    expect(page).to have_content('Google')
  end

end