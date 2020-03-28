# testrail-rspec
[![Gem Version](https://badge.fury.io/rb/testrail-rspec.svg)](http://badge.fury.io/rb/testrail-rspec)
> Sync `Rspec` test results with your `testrail` suite. Discover an example with Capybara in this gem source.

### Features
- [x] Update test results in the existing test run
- [x] Create dynamic test run and update test results in it
- [x] Update multi-testrail cases from a single automation scenario 
- [x] Delete/clean all the existing test runs in a project's suite before test run
- [x] Skip specific test-runs from deletion, when `clean_testrun` is set `true`
- [x] Static status comments on all the scenarios 
- [x] Support for RSpec `shared examples` 
- [x] Disable `testrail-rspec` execution on-demand
- [x] Support for environment variables to pass testrail config values

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

## Usage outline

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
Prefix multiple testrail case id(s) on start of your rspec scenario; say, `C845 C845 your scenario description`

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

#### Use context blocks to update cases
`Context blocks` with testrail case id(s) to make use of `Shared Examples`

```ruby
shared_examples 'log in' do
  it 'logs in'
end

shared_examples 'log out' do
  it 'logs out'
end

describe 'User login' do
  context 'Regular user' do
    let(:user) { create(:regular_user) }
    context 'C845 single case' do
      include_examples 'log in'
    end

    context 'C847' do
      include_examples 'log out'
    end
  end

  context 'Admin user' do
    let(:user) { create(:admin_user) }
    context 'C850 C853 multi cases' do
      include_examples 'log in'
    end

    context 'nothing to update in test-rail' do
      include_examples 'log out'
    end
  end
end
```

#### Configuration

1. Create a config file, `testrail_config.yml` in the project's parent folder
2. Enter the testrail details based on demand
3. To execute tests against the existing `Test Run`,
    ```yaml
    testrail:
      url: https://your_url.testrail.io/
      user: your@email.com
      password: ******
      run_id: 111
    ```
    Here, `run_id` is the dynamically generated id from your testrail account (say, `run_id: 111`)

4. To create a dynamic `Test Run` and to update results,
    ```yaml
    testrail:
      url: https://your_url.testrail.io/
      user: your@email.com
      password: ******
      project_id: 10
      suite_id: 110
    ```
    Here, `project_id` and `suite_id` are the dynamically generated id from your testrail account; `run_id` is optional in this case.

5. To delete all test-runs before execution,
    ```yaml
    testrail:
      url: https://your_url.testrail.io/
      user: your@email.com
      password: ******
      clean_testrun: true
      project_id: 10
      suite_id: 110
    ```
    Set, `clean_testrun: false` if you don't want to clean the existing test runs; but this keyword is optional.

6. Skip specific test-runs from deletion: set `clean_testrun: true` & `skip_testrun_ids: value, ...`
    ```yaml
    testrail:
      url: https://your_url.testrail.io/
      user: your@email.com
      password: ******
      clean_testrun: true
      skip_testrun_ids: 473, 475
      project_id: 10
      suite_id: 110
    ```
    Here, `skip_testrun_ids: value` is optional.

7. Disable `testrail-rspec` execution: set `allow: yes` 
    ```yaml
    testrail:
      url: https://your_url.testrail.io/
      user: your@email.com
      password: ******
      run_id: 111
      allow: no
    ```
    Here, `allow: yes` is optional. 

8. Use Environment variables to pass testrail config values 
    ```yaml
    testrail:
      url: ENV['URL']
      user: ENV['TESTRAIL_USER']
      password: ENV['TESTRAIL_PASSWORD']
      run_id: ENV['RUN_ID']
      clean_testrun: false
      project_id: 10
      suite_id: 110
    ```
    Example, `rake ./demo_spec.rb TESTRAIL_USER=your@email.com TESTRAIL_PASSWORD=****** RUN_ID=564 URL=https://your_url.testrail.io/` 

#### Hooks

Update the results through `Hooks` on end of each test
```
config.after(:each) do |scenario|
    TestrailRSpec::UpdateTestRails.new(scenario).upload_result
end
```

**Is there any demo available for this gem?**

Yes, you can use this `capybara` demo as an example, https://github.com/prashanth-sams/testrail-rspec

```
bundle install
rake test
```
