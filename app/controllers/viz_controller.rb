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

	def allCorpus
		@allSessions = Session.all
	end


	def timelineWithBrush
		# Params to know what to drwa
		@cyberdojo_id = params[:id]
		@cyberdojo_avatar = params[:avatar]
		@currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
		gon.compiles = @currSession.compiles

		allPhases = Array.new
		@currSession.cycles.each do |cycle|
			puts cycle.inspect
			cycleStart = 0
			cycleEnd = 0
			puts cycle.phases.inspect
			cycle.phases.each do |phase|
				phase.first_compile_in_phase = phase.compiles.first.git_tag
				phase.last_compile_in_phase = phase.compiles.last.git_tag
				print  "cycleStart:"
				puts cycleStart
				print  "cycleEnd:"
				puts cycleEnd
				allPhases << phase
			end
		end
		puts allPhases.size
		puts allPhases
		gon.phases = allPhases
		gon.cyberdojo_id = @cyberdojo_id
		gon.cyberdojo_avatar = @cyberdojo_avatar
	end

	def retrieve_session
		start_id = params[:start]
		end_id = params[:end]
		cyberdojo_id = params[:cyberdojo_id]
		cyberdojo_avatar = params[:cyberdojo_avatar]
		print "Start:"
		print start_id
		print "  End:"
		puts end_id

		# puts "@cyberdojo_id"
		@cyberdojo_id
		@cyberdojo_avatar
		# allFiles.push(dojo.katas['0A0D302A01'].avatars['cheetah'].lights[1].tag.visible_files)

		names = Hash.new
		names["start"] = dojo.katas[cyberdojo_id].avatars[cyberdojo_avatar].lights[start_id.to_i].tag.visible_files
		names["end"] = dojo.katas[cyberdojo_id].avatars[cyberdojo_avatar].lights[end_id.to_i].tag.visible_files

		puts names

		# <%= @katas['0A0D302A01'].avatars['cheetah'].lights[1].tag.visible_files['FizzBuzz.java'] %>
		# @katas['0A0D302A01'].avatars['cheetah'].lights[1].tag.visible_files['FizzBuzz.java']
		puts dojo.katas['0A0D302A01']

		@oneSession = Session.all.first
		respond_to do |format|
			format.html
			# format.json { render :json => @oneSession }
			format.json { render :json => names }
		end
	end


end
