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

	end


end
