require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks

# Save test results to a file
task :generate_test_results do
  puts "Runnings Tests"
  system("rspec -c > rspec_results.txt")
  puts "Saved!"
  puts "Results:"
  system("cat rspec_results.txt")
end