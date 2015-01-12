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
		
		puts "Path" +path 
		FileUtils.mkdir_p path, :mode => 0700
		
		puts Dir.pwd

		files.each do |file|
			#create file and write all content to it
			File.open(path + "/" + file, 'w') { |f| f.write(light.tag.visible_files[file]) }
			
			#save filenames and filepaths
			filenames << (file)
			puts path + "/" + file if DEBUG
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
	Session.where("id = ?", "2456").find_each do |session|
		print "id: " + session.id.to_s + ", " if DEBUG
		print "cyberdojo_id: " + session.cyberdojo_id.to_s + ", " if DEBUG
	    print "language: " + session.language_framework.to_s + ", " if DEBUG
		print "avatar: " + session.avatar.to_s + "\n" if DEBUG

		#HANDLE THE FIRST COMPILE POINT
		puts session.compiles[0].inspect
		# puts dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0]
		firstCompile = session.compiles.first
		curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0])
		curr_files = curr_files.select{ |filename| filename.include? ".java" }
		curr_filenames = curr_files.map{ |file| File.basename(file) }

		testChanges = false
		productionChanges = false
		firstCompile.total_method_count = 0
		firstCompile.total_assert_count = 0

		curr_path = "#{BUILD_DIR}/1/src"
		curr_filenames.each do |filename|

			puts curr_path + "/" + filename
			puts "((((((())))))))"
			if findFileType(curr_path + "/" + filename) == "Production"
				productionChanges = true
			end
			if findFileType(curr_path + "/" + filename) == "Test"
				testChanges = true
			end
			firstCompile.total_method_count += findMethods(curr_path + "/" + filename)
			firstCompile.total_assert_count += findAsserts(curr_path + "/" + filename)
		end

		puts "testChanges: "+ testChanges.to_s
		puts "productionChanges: "+ productionChanges.to_s
	
		firstCompile.test_change = testChanges
		firstCompile.prod_change = productionChanges
		firstCompile.total_method_count
		firstCompile.total_assert_count
		firstCompile.save
		puts "----------------------"


		session.compiles.each_cons(2) do |prev, curr|
			puts "prev: " + prev.git_tag.to_s + " -> curr: " + curr.git_tag.to_s

			prev_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[prev.git_tag-1])
			curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[curr.git_tag-1])

			prev_files = prev_files.select{ |filename| filename.include? ".java" }
			curr_files = curr_files.select{ |filename| filename.include? ".java" }

			prev_filenames = prev_files.map{ |file| File.basename(file) }
			curr_filenames = curr_files.map{ |file| File.basename(file) }

			testChanges = false
			productionChanges = false
			curr.total_method_count = 0
			curr.total_assert_count = 0
			# cycle for each prev_files that exists in curr_files, run diff
			curr_filenames.each do |filename|

				prev_path = "#{BUILD_DIR}/" + prev.git_tag.to_s + "/src"
				curr_path = "#{BUILD_DIR}/" + curr.git_tag.to_s + "/src"
				# puts "File To Match" + filename
				if prev_filenames.include?(filename)
					 if findChangeType(filename,prev_path,curr_path) == "Production"
					 	productionChanges = true
					 end
					 if findChangeType(filename,prev_path,curr_path) == "Test"
					 	testChanges = true
					 end
				else
					 if findFileType(curr_path + "/" + filename) == "Production"
					 	productionChanges = true
					 end
					 if findFileType(curr_path + "/" + filename) == "Test"
					 	testChanges = true
					 end
				end

			#Calculate Number of methods and asserts
			curr.total_method_count += findMethods(curr_path + "/" + filename)
			curr.total_assert_count += findAsserts(curr_path + "/" + filename)

			end
			puts "testChanges: "+ testChanges.to_s
			puts "productionChanges: "+ productionChanges.to_s

			curr.test_change = testChanges
			curr.prod_change = productionChanges
			curr.total_method_count
			curr.total_assert_count
			curr.save
			puts "----------------------"

		end
	end

	FileUtils.remove_entry_secure(BUILD_DIR)
end