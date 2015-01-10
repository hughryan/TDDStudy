root = '../'
require 'set'
require 'fileutils'
require_relative root + 'ASTInterface/ASTInterface'
require_relative root + 'OsDisk'			# required for dojo definition
require_relative root + 'Git'				# required for dojo definition
require_relative root + 'DummyTestRunner'	# required for dojo definition

ALLOWED_LANGS = Set["Java-1.8_JUnit"]
BUILD_DIR = 'ast_builds'

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

def build_files(light)
	filenames = []
	filepaths = []

	#restrict to only lights that contain files
	if light
		files = light.tag.visible_files.keys.select{ |filename| filename.include? ".java" }
		path = "#{BUILD_DIR}/" + light.number.to_s + "/src"
		FileUtils.mkdir_p path, :mode => 0700
		
		files.each do |file|
			#create file and write all content to it
			File.open(path + "/" + file, 'w') { |f| f.write(light.tag.visible_files[file]) }
			
			#save filenames and filepaths
			filenames << (file)
			filepaths << (path + "/" + file)
		end
	end
	
	filepaths
end


desc "parse Java project files and git to determine # of methods and # of asserts at each compile"
task :analyze_ast => :environment do
	ast_processing
end

def ast_processing
	FileUtils.mkdir_p BUILD_DIR, :mode => 0700

	# limit to kata sessions that use supported language/testing frameworks
#	Session.where("language_framework = ?", ALLOWED_LANGS).find_each do |session|
	Session.where("cyberdojo_id = ?", "35832862D3").find_each do |session|
		print "id: " + session.id.to_s + ", " if DEBUG
		print "cyberdojo_id: " + session.cyberdojo_id.to_s + ", " if DEBUG
	    print "language: " + session.language_framework.to_s + ", " if DEBUG
		print "avatar: " + session.avatar.to_s + "\n" if DEBUG

		session.compiles.each_cons(2) do |prev, curr|
			puts "prev: " + prev.git_tag.to_s + " -> curr: " + curr.git_tag.to_s

			prev_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[prev.git_tag-1])
			curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[curr.git_tag-1])

			prev_files = prev_files.select{ |filename| filename.include? ".java" }
			curr_files = curr_files.select{ |filename| filename.include? ".java" }


			# cycle for each prev_files that exists in curr_files, run diff

			puts "prev: #{prev_files}"
			puts "curr: #{curr_files}"

			prev_filenames = prev_files.map{ |file| File.basename(file) }
			curr_filenames = curr_files.map{ |file| File.basename(file) }

			intersection = (prev_filenames & curr_filenames)
			num = intersection.length
			puts "common (#{num}): #{intersection}"

			puts "----------------------"

		end
	end

=begin
		session.compiles.each_with_index do |curr, index|
			curr.total_method_count = 0
			curr.total_assert_count = 0
			light = dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[curr.git_tag]

			if light	# only lights that do not contain nil should be evaluated for files
				files = light.tag.visible_files.keys.select{ |filename| filename.include? ".java" }
				path = "#{build_dir}/" + light.number.to_s + "/src"
				FileUtils.mkdir_p path, :mode => 0700

				files.each do |file|
					file = File.basename()
					File.open(path + "/" + file, 'w') { |f| f.write(light.tag.visible_files[file]) }					
					curr.total_method_count += findMethods(path + "/" + file)
					curr.total_assert_count += findAsserts(path + "/" + file)
				end
			
			print "  " + curr.git_tag.to_s + ":\t" if DEBUG
			print "methods: " + curr.total_method_count.to_s + ", " if DEBUG
			print "asserts: " + curr.total_assert_count.to_s + "\n" if DEBUG

			curr.save
			end
		end
=end

	FileUtils.remove_entry_secure(BUILD_DIR)
end