# testrail-rspec
> Sync `Rspec` test results with your `testrail` suite

**Install gem file**
```
gem 'testrail-rspec'
```

**Import the library in your env file**
```
require 'testrail-rspec'
```

**Sync Case ID in your BDD scenario**

Prefix TestRail Case ID on start of your rspec scenario; say, `C860`

```
  describe 'Verify Google Home Page' do
    
    scenario 'C845 verify the Google home page' do
      expect(page).to have_content('Google')
    end
  
    scenario 'C847 verify the Google home page to fail' do
      expect(page).to have_content('Goo gle')
    end
    
    scenario 'C850 verify the Google home page to be pending' do
      pending
    end
    
    scenario 'C853 verify the Google home page to skip' do
      skip "skipping this test"
    end
  
  end
```

**Config TestRail details**

- Create a testrail config file, `testrail_config.yml` in the project parent folder
- Fill up the testrail details on right hand side of the fields (`url`, `user`, `password`, and `run_id`); `run_id` is the dynamically generated id from your testrail account (say, `run_id: 111`)

```
testrail:
  url: https://your_url.testrail.io/
  user: your@email.com
  password: ******
  run_id: 111
```

**Update the results through Hooks on end of each test**
```
config.after(:each) do |scenario|
    TestrailRSpec::UpdateTestRails.new(scenario).upload_result
end
```

**Is there a demo available for this gem?**

Yes, you can use this `capybara` demo as an example, https://github.com/prashanth-sams/testrail-rspec

```
bundle install
rake test
```
