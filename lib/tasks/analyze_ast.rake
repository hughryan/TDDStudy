root = '../'
require 'set'
require_relative root + 'ASTInterface/ASTInterface'
require_relative root + 'OsDisk'
require_relative root + 'Git'
require_relative root + 'DummyTestRunner'

ALLOWED_LANGS = Set["Java-1.8_JUnit"]

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

desc "parse Java project files at each compile"
task :analyze_ast => :environment do
	
	# puts "METHODS"
	# puts "methods: " + findMethods("/home/nelsonni/workspace/TDDStudy/lib/tasks/Example_v0.java")

	@katas = dojo.katas
  	@katas.each do |kata|
  		# restrict to only katas of a specific language/framework set; ALLOWED_LANGS
  		next unless ALLOWED_LANGS.include?(kata.language.name.to_s)
	    print "id: " + kata.id + ", "
	    print "language: " + kata.language.name + ", "
	    print "avatars: " + kata.avatars.active.count.to_s + "\n"
	    kata.avatars.active.each do |avatar|
	    	avatar.lights.each_with_index do |curr, index|
	    		#puts "curr: #{curr}, index: #{index}"
	    		fileNames = curr.tag.visible_files.keys
	    		javaFiles = fileNames.select { |name|  name.include? "java" }
	    		currLightDir =  "workingDir/"+curr.number.to_s

				`rm -rf workingDir/*`
				`mkdir workingDir/`
				`mkdir #{currLightDir}`
				`mkdir #{currLightDir}/src`

	    		javaFiles.each do |javaFileName|
	    			File.open(currLightDir+"/src/"+javaFileName, 'w') {|f| f.write(curr.tag.visible_files[javaFileName]) }
	    			puts "FILE: " + currLightDir+"/src/"+javaFileName + ", METHODS: " + findMethods(currLightDir+"/src/"+javaFileName)
	    		end
			end
	    end
	end

	`rm -rf workingDir/`
end