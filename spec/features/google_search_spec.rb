feature 'Verify Google Home Page' do
  before do
    @app.google_home.load
  end

  scenario 'C845 verify the Google home page to pass' do
    expect(page).to have_content('Google')
  end

  scenario 'C847 verify the Google home page to fail' do
    expect(page).to have_content('Goo gle')
  end

  scenario 'C850 verify the Google home page to skip' do
    skip "skipping this test"
  end

  scenario 'C856 C859 C860 verify the Google home page to skip' do
    expect(page).to have_content('Goo gle')
  end

  scenario 'verify the Google home page to skip' do
    expect(page).to have_content('Google')
  end

end