root = '../'
require 'set'
require_relative root + 'ASTInterface/ASTInterface'
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


desc "parse Java project files and git to determine # of methods and # of asserts at each compile"
task :analyze_ast => :environment do
	ast_processing
end

def ast_processing

=begin
	Session.all.each do |session|
	    print session.cyberdojo_id.to_s+ " "
	    print session.language_framework.to_s+ " "
		#      print "Number ACTIVE avatars:"
		#      puts  kata.avatars.active.count
		#      puts  kata.id
		print session.avatar.to_s+ " \n"

		session.compiles.each_with_index do |curr, index|

		end
	end
=end

	@katas = dojo.katas
  	@katas.each do |kata|
  		# restrict to only katas of a specific language/framework set: ALLOWED_LANGS
  		next unless ALLOWED_LANGS.include?(kata.language.name.to_s)
	    print "id: " + kata.id + ", "
	    print "language: " + kata.language.name + ", "
	    print "avatars: " + kata.avatars.active.count.to_s + "\n"
	    kata.avatars.active.each do |avatar|
	    	avatar.lights.each_with_index do |curr, index|
	    		fileNames = curr.tag.visible_files.keys
	    		javaFiles = fileNames.select { |name|  name.include? "java" }
	    		currLightDir =  "workingDir/"+curr.number.to_s

				`rm -rf workingDir/*`
				`mkdir workingDir/`
				`mkdir #{currLightDir}`
				`mkdir #{currLightDir}/src`

	    		javaFiles.each do |javaFileName|
	    			File.open(currLightDir+"/src/"+javaFileName, 'w') {|f| f.write(curr.tag.visible_files[javaFileName]) }
	    			print "file: " + javaFileName + ", "
	    			print "methods: " + findMethods(currLightDir+"/src/"+javaFileName) + ", "
	    			print "asserts: " + findAsserts(currLightDir+"/src/"+javaFileName) + "\n"
	    		end
			end
	    end
	end

	`rm -rf workingDir/`
end