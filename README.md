# testrail-rspec
[![Gem Version](https://badge.fury.io/rb/testrail-rspec.svg)](http://badge.fury.io/rb/testrail-rspec)
> Sync `Rspec` test results with your `testrail` suite. Discover an example with Capybara in this gem source.

### Features
- [x] Update test results in the existing test run
- [x] Create dynamic tlts in the existing test run
- [x] Update multi-testrail cases from a single automation scenario 

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'testrail-rspec'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install testrail-rspec
```

**Import the library in your `spec_helper.rb` file**
```
require 'testrail-rspec'
```

## #Usage outline

#### Update one case at a time
Prefix TestRail Case ID on start of your rspec scenario; say, `C845`

```ruby
  describe 'Verify Google Home Page' do
    
    scenario 'C845 verify the Google home page' do
      expect(page).to have_content('Google')
    end
  
    scenario 'C847 verify the Google home page to fail' do
      expect(page).to have_content('Goo gle')
    end
    
    scenario 'C853 verify the Google home page to skip' do
      skip "skipping this test"
    end
  
  end
```

#### Update multi-cases at a time

Prefix multiple TestRail Case IDs on start of your rspec scenario; say, `C845 C845 your scenario description`

```ruby
  describe 'Verify Google Home Page' do
    
    scenario 'C847 C846 C845 verify the Google home page' do
      expect(page).to have_content('Google')
    end
  
    scenario 'C848 C849 verify the Google home page to fail' do
      expect(page).to have_content('Goo gle')
    end
    
    scenario 'verify the Google home page to fail' do
      expect(page).to have_content('Goo gle')
    end
    
  end
```

#### TestRail details

Provide TestRail details by creating a config file, `testrail_config.yml` in the project parent folder

> With existing `Test Run`

- Add testrail details (`url`, `user`, `password`, and `run_id`)
- `run_id` is the dynamically generated id from your testrail account (say, `run_id: 111`)

```yaml
testrail:
  url: https://your_url.testrail.io/
  user: your@email.com
  password: ******
  run_id: 111
```

> Create dynamic `Test Run` and update results

- Add testrail details following `project_id` and `suite_id`
- `project_id` and `suite_id` are the dynamically generated id from your testrail account
- `run_id` is optional here; you may (or) may not have it in this case

```yaml
testrail:
  url: https://your_url.testrail.io/
  user: your@email.com
  password: ******
  project_id: 10
  suite_id: 110
```

#### Hooks

Update the results through `Hooks` on end of each test
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
