root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

class VizController < ApplicationController
	def index
		@allSessions = Session.all
		@katas = dojo.katas
	end

	def dojo
		externals = {
			:disk   => OsDisk.new,
			:git    => Git.new,
			:runner => DummyTestRunner.new
		}
		Dojo.new(root_path,externals)
	end

	def root_path
		Rails.root.to_s + '/'
	end

	def timelineWithBrush
		@allSessions = Session.all
		@katas = dojo.katas

		# render json: @allSessions
		gon.compiles = @allSessions.first.compiles

		allPhases = Array.new
		@allSessions.first.cycles.each do |cycle|
			cycleStart = 0
			cycleEnd = 0
			cycle.phases.each do |phase|
				phase.first_compile_in_phase = phase.compiles.first.id
				phase.last_compile_in_phase = phase.compiles.last.id
				print  "cycleStart:"
				puts cycleStart
				print  "cycleEnd:"
				puts cycleEnd
			end
			allPhases.push(cycle.phases)
		end
		gon.phases = allPhases



		# gon.cycles = @allSessions.first.phase
	end


end
