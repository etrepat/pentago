require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = '--colour --format progress'
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.verbose = true
end

task :default => :spec

