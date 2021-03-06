#!/usr/bin/env rake

require 'rake/clean'

begin
	require 'hoe'
rescue LoadError
	abort "This Rakefile requires 'hoe' (gem install hoe)"
end

Hoe.plugin :mercurial
Hoe.plugin :signing
Hoe.plugin :deveiate
Hoe.plugin :bundler
Hoe.plugin :gemspec

Hoe.plugins.delete :rubyforge

hoespec = Hoe.spec 'loggability' do
	self.readme_file = 'README.rdoc'
	self.history_file = 'History.rdoc'
	self.extra_rdoc_files = FileList[ '*.rdoc' ]

	self.developer 'Michael Granger', 'ged@FaerieMUD.org'

	self.dependency 'hoe-gemspec',    '~> 1.0.0', :developer
	self.dependency 'hoe-deveiate',    '~> 0.3', :developer
	self.dependency 'hoe-bundler',     '~> 1.2', :developer
	self.dependency 'simplecov',       '~> 0.7', :developer
	self.dependency 'configurability', '~> 2.0', :developer

	self.license "Ruby"
	self.require_ruby_version( '>=1.9.2' )
	self.hg_sign_tags = true if self.respond_to?( :hg_sign_tags= )
	self.check_history_on_release = true if self.respond_to?( :check_history_on_release= )

	self.rdoc_locations << "deveiate:/usr/local/www/public/code/#{remote_rdoc_dir}"
end

ENV['VERSION'] ||= hoespec.spec.version.to_s

# Ensure the specs pass before checking in
task 'hg:precheckin' => [ :check_history, 'bundler:gemfile', :check_manifest, :spec ]


desc "Build a coverage report"
task :coverage do
	ENV["COVERAGE"] = 'yes'
	Rake::Task[:spec].invoke
end

# Use the fivefish formatter for docs generated from development checkout
if File.directory?( '.hg' )
	require 'rdoc/task'

	Rake::Task[ 'docs' ].clear
	RDoc::Task.new( 'docs' ) do |rdoc|
	    rdoc.main = "README.rdoc"
	    rdoc.rdoc_files.include( "*.rdoc", "ChangeLog", "lib/**/*.rb" )
	    rdoc.generator = :fivefish
	    rdoc.rdoc_dir = 'doc'
	end
end

