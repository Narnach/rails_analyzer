Gem::Specification.new do |s|
  # Project
  s.name         = 'rails_analyzer'
  s.summary      = "RailsAnalyzer generates reports about requests processed by a Ruby on Rails server."
  s.description  = "RailsAnalyzer generates reports about requests processed by a Ruby on Rails server."
  s.version      = '0.1.0'
  s.date         = '2008-09-15'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Wes Oldenbeuving"]
  s.email        = "narnach@gmail.com"
  s.homepage     = "http://www.github.com/Narnach/rails_analyzer"

  # Files
  root_files     = %w[MIT-LICENSE README.rdoc Rakefile rails_analyzer.gemspec]
  bin_files      = %w[rails_analyzer]
  lib_files      = %w[rails_analyzer float_ext array_ext pretty_log time_stats hit_stats entries url_hits]
  test_files     = %w[]
  spec_files     = %w[rails_analyzer]
  other_files    = %w[spec/spec.opts spec/spec_helper.rb]
  s.bindir       = "bin"
  s.require_path = "lib"
  s.executables  = bin_files
  s.test_files   = test_files.map {|f| 'test/%s_test.rb' % f} + spec_files.map {|f| 'spec/%s_spec.rb' % f}
  s.files        = root_files + s.test_files + other_files + bin_files.map {|f| 'bin/%s' % f} + lib_files.map {|f| 'lib/%s.rb' % f}

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.rdoc MIT-LICENSE]
  s.rdoc_options << '--inline-source' << '--line-numbers' << '--main' << 'README.rdoc'

  # Requirements
  s.required_ruby_version = ">= 1.8.0"
end
