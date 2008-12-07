#!/usr/bin/env ruby

require "logger"

class Raziel
	attr_accessor :logger
	attr_accessor :state

	def initialize
		self.logger = Logger.new(File.dirname(__FILE__) + "/raziel.rb.log")
		self.state = :null	

		write "RobotOption 3 0"
		write "RobotOption 1 1"
	end

	def read
		input = $stdin.gets
    logger.info(input)
		check_state(input)
	end

	def write(string, log = true)
		$stdout.puts(string)
    $stdout.flush
	end

	def check_state(input)
		old_state = state
		case input
		when /Initialize 1/
			self.state = :initialized
		when /GameStarts/
			self.state = :running
		when /Dead/, /GameFinishes/
			self.state = :finished
		when /ExitRobot/
			exit
		end

		if old_state != state
			logger.info("State change: #{old_state} to #{state}")
			state_updated(old_state, state)
		end

    act
	end

	def state_updated(from, to)
		if from == :null and to == :initialized
			init
		elsif from == :initialized and to == :running
			start
		end
	end

	def init
		write "Name razziel.rb"
		write "Colour ffcc33 336699"
	end

	def start
		write "Accelerate 0.5"
		write "Rotate 7 3"
	end

	def fire
		write "Shoot 10", false
	end

  def act
    fire if state == :running
  end

	def read_loop
		loop do
			read
		end
	end
end

$raziel = Raziel.new

reader = Thread.new do
	$raziel.read_loop
end

require File.dirname(__FILE__) + "/irb/server"

reader.join
