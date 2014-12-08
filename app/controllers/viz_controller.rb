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
		cookies[:user_name] = "Hilton"
		# puts "cookies[:username]"
		# puts cookies[:user_name]
		# cookies.delete :user_name

		@allSessions = Session.all
	end

	def manualCatTool
		puts "cookies[:username]"
		gon.username = cookies[:user_name]

		# Params to know what to drwa
		@cyberdojo_id = params[:id]
		@cyberdojo_avatar = params[:avatar]
		@currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
		gon.compiles = @currSession.compiles


		# gon.username = cookies[:username]
		allMarkups = Hash.new

		# markups = Markup.where(session: @currSession, user: )
		@currSession.markups.each do |markup|

			if allMarkups.has_key?(markup.user)
				# puts allMarkups[markup.user]
				allMarkups[markup.user] << markup
			else
				currMarkup = Array.new
				currMarkup << markup
				allMarkups[markup.user] = currMarkup
			end
			puts "MARKUP"
			puts markup.user
			puts markup.inspect
		end

		gon.allMarkups = allMarkups
		# markups = Markup.where(session: )

		# allCycles = Array.new
		# allPhases = Array.new
		# normalizedPhaseTime = Array.new
		# normalizedPhaseSLOC = Array.new
		# @currSession.cycles.each do |cycle|
		# 	puts cycle.inspect
		# 	currCycle = Hash.new
		# 	currCycle[:valid_tdd] = cycle.valid_tdd
		# 	currCycle[:startCompile] = cycle.phases.first.compiles.first.git_tag
		# 	currCycle[:endCompile] = cycle.phases.last.compiles.last.git_tag
		# 	allCycles << currCycle

		# 	cycleStart = 0
		# 	cycleEnd = 0
		# 	puts cycle.phases.inspect
		# 	totalCycleTime = 0
		# 	totalCycleSloc = 0
		# 	currPhaseTime = Hash.new
		# 	currPhaseSloc = Hash.new
		# 	cycle.phases.each do |phase|
		# 		phase.first_compile_in_phase = phase.compiles.first.git_tag
		# 		phase.last_compile_in_phase = phase.compiles.last.git_tag
		# 		print  "cycleStart:"
		# 		puts cycleStart
		# 		print  "cycleEnd:"
		# 		puts cycleEnd

		# 		totalCycleSloc = totalCycleSloc + phase.total_sloc_count
		# 		totalCycleTime = totalCycleTime + phase.seconds_in_phase

		# 		allPhases << phase
		# 	end
		# 	cycle.phases.each do |phase|
		# 		print "totalCycleSloc"
		# 		puts totalCycleSloc
		# 		print  "totalCycleTime"
		# 		puts totalCycleTime
		# 		currPhaseTime[phase.tdd_color] = phase.total_sloc_count.to_f/totalCycleSloc.to_f
		# 		currPhaseSloc[phase.tdd_color] = phase.seconds_in_phase.to_f/totalCycleTime.to_f
		# 		normalizedPhaseTime.push(currPhaseTime)
		# 		normalizedPhaseSLOC.push(currPhaseSloc)
		# 		print "currPhaseTime::"
		# 		puts currPhaseTime.inspect
		# 		print "currPhaseSloc::"
		# 		puts currPhaseSloc.inspect
		# 	end
		# end
		# puts allPhases.size
		# puts allPhases
		gon.phases = Array.new
		gon.cyberdojo_id = @cyberdojo_id
		gon.cyberdojo_avatar = @cyberdojo_avatar
		# gon.normalizedPhaseTime = normalizedPhaseTime
		# gon.normalizedPhaseSLOC = normalizedPhaseSLOC
		# gon.cycles = allCycles
	end



	def timelineWithBrush
		# Params to know what to drwa
		@cyberdojo_id = params[:id]
		@cyberdojo_avatar = params[:avatar]
		@currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
		gon.compiles = @currSession.compiles

		allCycles = Array.new
		allPhases = Array.new
		normalizedPhaseTime = Array.new
		normalizedPhaseSLOC = Array.new
		@currSession.cycles.each do |cycle|
			puts cycle.inspect
			currCycle = Hash.new
			currCycle[:valid_tdd] = cycle.valid_tdd
			currCycle[:startCompile] = cycle.phases.first.compiles.first.git_tag
			currCycle[:endCompile] = cycle.phases.last.compiles.last.git_tag
			allCycles << currCycle

			cycleStart = 0
			cycleEnd = 0
			puts cycle.phases.inspect
			totalCycleTime = 0
			totalCycleSloc = 0
			currPhaseTime = Hash.new
			currPhaseSloc = Hash.new
			cycle.phases.each do |phase|
				phase.first_compile_in_phase = phase.compiles.first.git_tag
				phase.last_compile_in_phase = phase.compiles.last.git_tag
				print  "cycleStart:"
				puts cycleStart
				print  "cycleEnd:"
				puts cycleEnd

				totalCycleSloc = totalCycleSloc + phase.total_sloc_count
				totalCycleTime = totalCycleTime + phase.seconds_in_phase

				allPhases << phase
			end
			cycle.phases.each do |phase|
				print "totalCycleSloc"
				puts totalCycleSloc
				print  "totalCycleTime"
				puts totalCycleTime
				currPhaseTime[phase.tdd_color] = phase.total_sloc_count.to_f/totalCycleSloc.to_f
				currPhaseSloc[phase.tdd_color] = phase.seconds_in_phase.to_f/totalCycleTime.to_f
				normalizedPhaseTime.push(currPhaseTime)
				normalizedPhaseSLOC.push(currPhaseSloc)
				print "currPhaseTime::"
				puts currPhaseTime.inspect
				print "currPhaseSloc::"
				puts currPhaseSloc.inspect
			end
		end
		puts allPhases.size
		puts allPhases
		gon.phases = allPhases
		gon.cyberdojo_id = @cyberdojo_id
		gon.cyberdojo_avatar = @cyberdojo_avatar
		gon.normalizedPhaseTime = normalizedPhaseTime
		gon.normalizedPhaseSLOC = normalizedPhaseSLOC
		gon.cycles = allCycles

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

		names["start"].delete("output")
		names["end"].delete("output")
		names["start"].delete("instructions")
		names["end"].delete("instructions")
		names["start"].delete("cyber-dojo.sh")
		names["end"].delete("cyber-dojo.sh")
		puts names

		# <%= @katas['0A0D302A01'].avatars['cheetah'].lights[1].tag.visible_files['FizzBuzz.java'] %>
		# @katas['0A0D302A01'].avatars['cheetah'].lights[1].tag.visible_files['FizzBuzz.java']
		# puts dojo.katas['0A0D302A01']

		@oneSession = Session.all.first
		respond_to do |format|
			format.html
			# format.json { render :json => @oneSession }
			format.json { render :json => names }
		end
	end


	def store_markup

		puts params[:phaseData]
		puts params[:cyberdojo_id]
		puts params[:cyberdojo_avatar]
		this_phase_data = params[:phaseData]
		this_cyberdojo_id = params[:cyberdojo_id]
		this_cyberdojo_avatar = params[:cyberdojo_avatar]

		currSession = Session.where(cyberdojo_id: this_cyberdojo_id, avatar: this_cyberdojo_avatar).first

		markup = Markup.new
		markup.tdd_color = this_phase_data["color"]
		markup.first_compile_in_phase = this_phase_data["start"]
		markup.last_compile_in_phase = this_phase_data["end"]
		markup.session = currSession
		markup.user = params[:user]
		markup.save

		names = Array.new
		respond_to do |format|
			format.html
			# format.json { render :json => @oneSession }
			format.json { render :json => names }
		end
	end

	def del_markup

		puts params[:phaseData]
		puts params[:cyberdojo_id]
		puts params[:cyberdojo_avatar]
		this_phase_data = params[:phaseData]
		this_cyberdojo_id = params[:cyberdojo_id]
		this_cyberdojo_avatar = params[:cyberdojo_avatar]

		currSession = Session.where(cyberdojo_id: this_cyberdojo_id, avatar: this_cyberdojo_avatar).first
		markup = Markup.find_by(session: currSession, user: params[:user], tdd_color: this_phase_data["color"],first_compile_in_phase: this_phase_data["start"], last_compile_in_phase: this_phase_data["end"])
		markup.destroy
		puts "MARKUP"
		puts markup.inspect

		names = Array.new
		respond_to do |format|
			format.html
			# format.json { render :json => @oneSession }
			format.json { render :json => names }
		end
	end

	def set_cookie

		puts "SET COOKIE:"
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		puts params[:username]
		# cookies[:username] = "{ value: params[:username], expires: 10.days.from_now }"

		# puts "cookies[:username]"
		# puts cookies[:username]

		cookies[:user_name] = params[:username]


		names = Array.new
		respond_to do |format|
			format.html
			# format.json { render :json => @oneSession }
			format.json { render :json => names }
		end
	end

	def del_cookie

		# puts "USERNAME:"
		# puts params[:username]
		# # cookies[:username] = "{ value: params[:username], expires: 10.days.from_now }"

		# # puts "cookies[:username]"
		# puts cookies[:username]

		# cookies[:user_name] = params[:username]

		puts "del"
		puts cookies[:username]

		cookies.delete :user_name

		puts "del"
		puts cookies[:username]
		# cookies.delete :user_name


		names = Array.new
		respond_to do |format|
			format.html
			# format.json { render :json => @oneSession }
			format.json { render :json => names }
		end
	end



end
