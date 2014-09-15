root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'


class CycleCatagorizerController < ApplicationController
  def cycle_catgories
  	@cycles = Cycle.all
  end

  def parseCSV
  	@filename = '/Users/michaelhilton/Development/TDDStudy/corpus.csv'
  	@CSVRows = SmarterCSV.process(@filename ,{:col_sep => "\|",  :force_simple_split => true })

  	@CSVRows.each do |row|
  		
  		kata = Kata.new do |k|
  			k.cyberdojo_id = row[:kataid]	
		end
  	end

  	#user = User.create(name: "David", occupation: "Code Artist")
  end

  def ListKatasInDojo
    @allSessions = Session.all
  end

  def root_path
    Rails.root.to_s + '/'
  end

  def dojo
    externals = {
    :disk   => OsDisk.new,
    :git    => Git.new,
    :runner => DummyTestRunner.new
    }
    Dojo.new(root_path,externals)
  end


  def ImportAllKatas
    @katas = dojo.katas
    Session.delete_all

    @katas.each do |kata| 
      kata.avatars.active.each do |avatar|
        session = Session.new do |s|
          s.kata_name = kata.exercise.name
          s.cyberdojo_id = kata.id 
          s.language_framework = kata.language.name 
          s.path = kata.path
          s.avatar = avatar.name
          s.start_date = kata.created
          s.total_light_count = avatar.lights.count 
          s.final_light_color = avatar.lights[avatar.lights.count-1].colour
        end
        session.save
      end
    end
  end






end
