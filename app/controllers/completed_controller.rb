root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

class CompletedController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def index
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

  def mark_completed
    @kata = params[:kata]
    allSessions = Session.where(language_framework: "Java-1.8_JUnit", kata_name: @kata, potential_complete: true)
    gon.allSessions = allSessions

  end

  def mark_kata
    id = params[:id]
    currSession = Session.where(id: id).first

    puts currSession.inspect
    puts currSession.cyberdojo_id

    allFiles = dojo.katas[currSession.cyberdojo_id].avatars[currSession.avatar].lights[currSession.total_light_count.to_i-1].tag.visible_files

    gon.allFiles = allFiles
    gon.is_complete = currSession.is_complete

  end

  def update_completion
    puts "%%%%%%%%%%%%%%%%%%update_markup$$$$$$$$$$$$$$$$$$"
    puts params[:complete]
    curr_id =  params[:id]

    currSession = Session.where(id: curr_id).first

    if params[:complete] == "Yes"
      currSession.is_complete = true
    end
    if params[:complete] == "No"
      currSession.is_complete = false
    end
    if params[:complete] == ""
      currSession.is_complete = ""
    end

    currSession.save

    names = Array.new
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end
end
