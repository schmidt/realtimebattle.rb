#! /usr/bin/ruby

require 'irb'
require 'drb'

module IRB
	def IRB.start_remote drb_uri
		DRb.start_service
		remote_service = DRbObject.new nil, drb_uri
		input_proc = proc do |prompt|
			l = Readline.readline prompt
			Readline::HISTORY.push(l) if l and !l.empty?
			l
		end
		output_proc = proc do |l|
			print l
		end
		remote_service.irb_start input_proc, output_proc
	end
end

IRB.start_remote ARGV[0]