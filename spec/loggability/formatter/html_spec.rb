# -*- rspec -*-
#encoding: utf-8

require_relative '../../helpers'

require 'tempfile'
require 'rspec'

require 'loggability/logger'
require 'loggability/formatter'
require 'loggability/formatter/html'


describe Loggability::Formatter::HTML do

	subject { described_class.new }

	it "formats messages as HTML" do
		subject.call( 'INFO', Time.at(1336286481), nil, "Foom." ).
			should =~ %r{<span class="log-message-text">Foom.</span>}i
	end

	it "formats exceptions into useful messages" do
		msg = nil

		begin
			raise ArgumentError, "invalid argument"
		rescue => err
			msg = subject.call( 'INFO', Time.at(1336286481), nil, err )
		end

		msg.should =~ %r{<span class=\"log-exc\">ArgumentError</span>}i
		msg.should =~ %r{<span class=\"log-exc-message\">invalid argument</span>}i
		msg.should =~ %r{ from <span class=\"log-exc-firstframe\">}i
	end

	it "formats regular objects into useful messages" do
		subject.call( 'INFO', Time.at(1336286481), nil, Object.new ).
			should =~ %r{<span class=\"log-message-text\">#&lt;Object:0x[[:xdigit:]]+&gt;</span>}
	end

	it "escapes the 'progname' part of log messages" do
		progname = "#<Class:0x007f9efa153d08>:0x7f9efa153c18"
		subject.call( 'DEBUG', Time.at(1336286481), progname, Object.new ).
			should =~ %r{#&lt;Class:0x0}
	end

end

