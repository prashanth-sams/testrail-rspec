Gem::Specification.new do |s|
  s.name          = "testrail-rspec"
  s.version       = "0.1.1"
  s.licenses      = ['MIT']
  s.author        = ["Prashanth Sams"]
  s.email         = ['sams.prashanth@gmail.com']
  s.summary       = "Sync Rspec test results with your testrail suite"
  s.files         = ["lib/testrail-rspec.rb", "lib/testrail-rspec/api-client.rb", "lib/testrail-rspec/update-testrails.rb", "lib/testrail-rspec/version.rb"]
  s.require_paths = ["lib"]
  s.metadata      = { "documentation_uri" => "https://www.rubydoc.info/github/prashanth-sams/testrail-rspec/master", "source_code_uri" => "https://github.com/prashanth-sams/testrail-rspec", "bug_tracker_uri" => "https://github.com/prashanth-sams/testrail-rspec/issues" }
end