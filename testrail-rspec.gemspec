lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "testrail-rspec/version"

Gem::Specification.new do |s|
  s.name          = "testrail-rspec"
  s.version       = TestrailRspec::VERSION
  s.authors       = ["Prashanth Sams"]
  s.email         = ['sams.prashanth@gmail.com']
  s.summary       = "Sync Rspec test results with your testrail suite. Discover an example with Capybara in this gem source"
  s.homepage      = "https://github.com/prashanth-sams/testrail-rspec"
  s.licenses      = ['MIT']
  s.files         = ["lib/testrail-rspec.rb", "lib/testrail-rspec/api-client.rb", "lib/testrail-rspec/update-testrails.rb", "lib/testrail-rspec/version.rb"]
  s.require_paths = ["lib"]
  s.metadata      = { "documentation_uri" => "https://www.rubydoc.info/github/prashanth-sams/testrail-rspec/master", "source_code_uri" => "https://github.com/prashanth-sams/testrail-rspec", "bug_tracker_uri" => "https://github.com/prashanth-sams/testrail-rspec/issues" }

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "capybara", "~> 3.0"
  s.add_development_dependency "selenium-webdriver", "~> 3.0"
  s.add_development_dependency "site_prism", "~> 3.0"
  s.add_development_dependency "byebug", "~> 11.0"
end