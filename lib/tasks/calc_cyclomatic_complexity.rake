task :calc_cyclomatic_complexity do
  calc_cyclomatic_complexity
end

# This data can be loaded with the rake db:seed (or created alongside the db with db:setup).
root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'
require_relative root + '/lib/ASTInterface/ASTInterface'


def root_path
  Rails.root.to_s + '/'
end



def calc_cyclomatic_complexity

  Session.where(language_framework: "Java-1.8_JUnit").each do |session|
    puts "*******************  NEW CYCLE  *******************"
    puts session.inspect

    lastCompile = session.compiles.last
    index = session.compiles.length -1
    @avatar = dojo.katas[session.cyberdojo_id].avatars[session.avatar]
    curr_light = @avatar.lights[index]
    copy_source_files_for_cyclomatic_complexity(curr_light,compile)


    # session.save
  end
end


# Session.find_by_sql("SELECT * FROM Sessions where id = 3578").each do |session_id|

#   puts "CURR SESSION ID: " + session_id.id.to_s if CYCLE_DIAG
#   puts session_id.inspect

#   Session.where("id = ?", session_id.id).find_each do |curr_session|
#     lastTime = nil
#     curr_session.compiles.each_with_index do |compile, index|

#       @runtests = 0
#       @runtestfails = 0
#       puts "compile.git_tag: "+ compile.git_tag.to_s

#       @avatar = dojo.katas[curr_session.cyberdojo_id].avatars[curr_session.avatar]
#       curr_light = @avatar.lights[index]
#       copy_source_files_to_working_dir(curr_light,compile)

#       puts "^^^^^^^^^^^^^^^^^^^^^^^"
#       puts  @runtests.to_s
#       puts  @runtestfails.to_s
#       puts "^^^^^^^^^^^^^^^^^^^^^^^"

#       compile.total_test_run_count = @runtests
#       compile.total_test_run_fail_count = @runtestfails
#       compile.save


#     end
#   end
# end
# end

def copy_source_files_for_cyclomatic_complexity(curLight,compile)
  # puts "COPY SOURCE FILES"
  fileNames = curLight.tag.visible_files.keys
  javaFiles = fileNames.select { |name|  name.include? "java" }
  currLightDir =  "./workingDir/"+curLight.number.to_s

  `rm -rf ./workingDir/*`
  `mkdir ./workingDir/`
  `mkdir #{currLightDir}`
  `mkdir #{currLightDir}/src`

  currTestClass = ""
  javaFiles.each do |javaFileName|
    File.open(currLightDir+"/src/"+javaFileName, 'w') {|f| f.write(curLight.tag.visible_files[javaFileName]) }
    initialLoc = javaFileName.to_s =~ /test/i
    unless initialLoc.nil?
      fileNameParts = javaFileName.split('.')
      currTestClass = fileNameParts.first
    end
  end
  # @statement_coverage = calc_test_coverage_in_dir(curLight,currTestClass,currLightDir)

  puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  puts "Current Light Color: " + curLight.colour.to_s
  # puts "statement_coverage: " + @statement_coverage.to_s
  # compile.statement_coverage = @statement_coverage
  # compile.test_sloc_count
  puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
end



def calc_test_coverage_in_dir(curLight,currTestClass,currLightDir)
  @statementCov = "NONE"
  if curLight.colour.to_s == "amber"
    return
  else

    # `mkdir ./workingDir`
    # `mkdir ./workingDir/codeCovg`
    `mkdir #{currLightDir}/isrc`
    # `rm -f ./workingDir/*`
    `rm -r ./*.clf`

    puts "starting Calc Coverage"
    # puts  "java -jar ./vendor/calcCodeCovg/libs/codecover-batch.jar instrument --root-directory #{currLightDir}/src --destination #{currLightDir}/isrc --container #{currLightDir}/con.xml --language java --charset UTF-8"
    # puts  "javac -cp ./vendor/calcCodeCovg/libs/*:#{currLightDir}/isrc #{currLightDir}/isrc/*.java"
    # puts  "java -cp ./vendor/calcCodeCovg/libs/*:#{currLightDir}/isrc org.junit.runner.JUnitCore #{currTestClass}"
    # puts  "java -jar ./vendor/calcCodeCovg/libs/codecover-batch.jar analyze --container #{currLightDir}/con.xml --coverage-log *.clf --name test1"
    # puts  "java -jar ./vendor/calcCodeCovg/libs/codecover-batch.jar report --container #{currLightDir}/con.xml --destination #{currLightDir}/report.csv --session test1 --template ./vendor/calcCodeCovg/report-templates/CSV_Report.xml"



    `java -jar ./vendor/calcCodeCovg/libs/codecover-batch.jar instrument --root-directory #{currLightDir}/src --destination #{currLightDir}/isrc --container #{currLightDir}/con.xml --language java --charset UTF-8`
    `javac -cp ./vendor/calcCodeCovg/libs/*:#{currLightDir}/isrc #{currLightDir}/isrc/*.java`
    results = `java -cp ./vendor/calcCodeCovg/libs/*:#{currLightDir}/isrc org.junit.runner.JUnitCore #{currTestClass}`
    `java -jar ./vendor/calcCodeCovg/libs/codecover-batch.jar analyze --container #{currLightDir}/con.xml --coverage-log *.clf --name test1`
    `java -jar ./vendor/calcCodeCovg/libs/codecover-batch.jar report --container #{currLightDir}/con.xml --destination #{currLightDir}/report.csv --session test1 --template ./vendor/calcCodeCovg/report-templates/CSV_Report.xml`

    puts results
    puts  "******************"


    runtests = 0
    runtestfails = 0

    results.lines.each do |item, obj|
      if item.include? "Tests run:"
        puts "String includes 'Tests run:'"
        puts "#{obj}: #{item}"

        re = /Tests run: (?<testRuns>\d+),  Failures: (?<testFails>\d+)/
        result = re.match(item)



        unless result.nil?
          runtests = result['testRuns'].to_i
          runtestfails = result['testFails'].to_i
          puts "runtests: "+ runtests.to_s
          puts "runtestfails: "+ runtestfails.to_s
          # end
        end





      end
      if item.include? "OK ("
        puts "String includes 'OK ('"
        puts "#{obj}: #{item}"

        re2 = /OK \((?<testRuns>\d+) tests*\)/
        result2 = re2.match(item)

        unless result2.nil?
          runtests = result2['testRuns'].to_i
          runtestfails = 0
          puts "runtests: "+ runtests.to_s
          puts "runtestfails: "+ runtestfails.to_s
          # end
        end
      end
      # puts "#{obj}: #{item}"
    end


    @runtests = runtests
    @runtestfails = runtestfails

    # puts results.lines.last



    if File.exist?(currLightDir + '/report.csv')
      codeCoverageCSV = CSV.read(currLightDir + '/report.csv')
      # puts "codeCovgCSV"
      # puts "$$$$$$$$$$$$$$$$$ codeCoverageCSV $$$$$$$$$$$$$$$$$$$$$$$"
      # puts codeCoverageCSV
      # puts "$$$$$$$$$$$$$$$$$ codeCoverageCSV $$$$$$$$$$$$$$$$$$$$$$$"
      unless(codeCoverageCSV.inspect() == "[]")
        @statementCov  = codeCoverageCSV[2][16]
      end
      return @statementCov
    end
  end
end
