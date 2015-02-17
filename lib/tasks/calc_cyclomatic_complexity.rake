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
    # path = "#{BUILD_DIR}/" + light.number.to_s + "/src"

    puts "*******************  NEW CYCLE  *******************"
    puts session.inspect

    lastCompile = session.compiles.last
    index = (session.compiles.count)-1
    # @avatar = dojo.katas[session.cyberdojo_id].avatars[session.avatar]
    # curr_light = @avatar.lights[index]
    # copy_source_files_for_cyclomatic_complexity(curr_light,lastCompile)
    total_cc = 0
    production_cc = 0
    test_cc = 0
    curr_light = dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index]
    curr_files = build_files(curr_light)
    curr_files = curr_files.select{ |filename| filename.include? ".java" }
    curr_filenames = curr_files.map{ |file| File.basename(file) }
    path = "#{BUILD_DIR}/" + lastCompile.git_tag.to_s + "/src"
    FileUtils.mkdir_p BUILD_DIR, :mode => 0700
    cycloText = ""

    Dir.entries(path).each do |currFile|
      # unless currFile.nil?
      # puts "currFile: " + currFile.to_s
      if currFile.to_s.length > 3
        file = path.to_s + "/" + currFile.to_s
        puts "output"
        puts "./vendor/complexity/javancss #{file}"
        cycloText =  `./vendor/complexity/javancss #{file}`

        cyclo_complex = ""
        puts cycloText
        re = /Java NCSS: (?<cyclo_complex>\d+)/
        cyclo_complex_result = re.match(cycloText)

        # puts cyclo_complex_result.inspect
        # puts cyclo_complex_result.length

        if cyclo_complex_result == nil
          puts "NO RESULTS"
        else

          # puts cyclo_complex_result
          # puts cyclo_complex
          # puts cycloText
          cyclo_complex =  cyclo_complex_result['cyclo_complex'].to_f
          # puts "./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}"
          # puts `pwd`
          # puts command
          # csv = CSV.parse(command)
          # puts " csv.to_s: " + csv.to_s
          # unless(csv.inspect == "[]")

          begin
            # puts "File Type: " + findFileType(file)
            if findFileType(file) == "Production"
              # puts "sloc: " + csv[2][4].to_i.to_s
              production_cc = cyclo_complex
              # production_sloc = production_sloc + csv[2][4].to_i
              # puts "PRODUCTION SLOC: " + production_sloc.to_s
            end
            if findFileType(file) == "Test"
              # test_sloc = test_sloc + csv[2][4].to_i
              test_cc = cyclo_complex
              # puts "TEST SLOC: " + test_sloc.to_s
            end
          rescue
            # puts "Error: Reading in calc_sloc"
          end
          # sloc = sloc + csv[2][4].to_i
          # end
          total_cc += cyclo_complex
        end
      end
    end
    puts "production_cc: " + production_cc.to_s
    puts "test_cc: "+ test_cc.to_s
    puts "total_cc: "+total_cc.to_s
    session.test_cyclomatic_complexity = test_cc
    session.production_cyclomatic_complexity = production_cc
    session.final_cyclomatic_complexity = test_cc + production_cc

    session.save
    FileUtils.remove_entry_secure(BUILD_DIR)
  end
end
