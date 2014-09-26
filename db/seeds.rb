# This data can be loaded with the rake db:seed (or created alongside the db with db:setup).
root = '..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

# Set to true for debug prints
DEBUG = false

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

def build_cycle_data
  Cycle.delete_all

  @NEW_EDIT_COUNT = true
  @TIME_CEILING = 1200 # Time Ceiling in Seconds Per Light
  @supp_test_langs = ["Java-1.8_JUnit", "Java-1.8_Mockito", "Java-1.8_Approval", "Java-1.8_Powermockito", "Python-unittest", "Python-pytest", "Ruby-TestUnit", "Ruby-Rspec", "C++-assert", "C++-GoogleTest", "C++-CppUTest", "C++-Catch", "C-assert", "Go-testing", "Javascript-assert", "C#-NUnit", "PHP-PHPUnit", "Perl-TestSimple", "CoffeeScript-jasmine", "Erlang-eunit", "Haskell-hunit", "Scala-scalatest", "Clojure-.test", "Groovy-JUnit", "Groovy-Spock"]
  @supp_fail_langs = ["Java-1.8_JUnit"]

  i = 0
  @katas = dojo.katas
  @katas.each do |kata|
    if(kata.language.name == "Java-1.8_JUnit")
      i+= 1
      kata.avatars.active.each do |avatar|

        #Initialize Data
        @start_date = kata.created
        @total_time = 0
        @redlights = 0
        @greenlights = 0
        @amberlights = 0
        @consecutive_reds = 0
        @avatar = avatar
        @kata = kata
        @cycles = 0
        @edited_lines = 0
        @totaltests = 0

        #Calculate Cycle Data
        calc_cycles

      end
      if(i > 4)
        break
      end
    end
  end
end

def import_all_katas
  @katas = dojo.katas
  Session.delete_all
  Compile.delete_all

  i = 0
  @katas.each do |kata|
    puts kata if DEBUG
    if(kata.language.name == "Java-1.8_JUnit")
      i+= 1
      kata.avatars.active.each do |avatar|
        session = Session.new do |s|
          s.cyberdojo_id = kata.id
          s.avatar = avatar.name
        end
        session.save

        s = Session.find_by(cyberdojo_id: kata.id, avatar: avatar.name)
        @redlights = 0
        @greenlights = 0
        @amberlights = 0
        @path = avatar.path
        @sloc = 0
        @test_loc = 0
        @production_loc = 0
        @language = kata.language.name
        @runtests = 0
        @runtestfails = 0
        s.kata_name = kata.exercise.name
        # s.cyberdojo_id = kata.id
        s.language_framework = kata.language.name
        s.path = kata.path
        # s.avatar = avatar.name
        s.start_date = kata.created
        s.total_light_count = avatar.lights.count
        s.final_light_color = avatar.lights[avatar.lights.count-1].colour
        maxRedString = 1
        currRedString = 1
        lastLightColor = "none"
        avatar.lights.each do |curr_light|
          #Count Types of Lights
          case curr_light.colour.to_s
          when "red"
            @redlights += 1
            if(lastLightColor == "red")
              currRedString += 1
              if(currRedString > maxRedString)
                maxRedString = currRedString
              end
            else
              lastLightColor = "red"
            end
          when "green"
            @greenlights += 1
            lastLightColor = "green"
            currRedString = 1
          when "amber"
            @amberlights += 1
            lastLightColor = "amber"
            currRedString = 1
          end

          puts "*********************DEBUG*********************" if DEBUG
          #puts curr_light.tag.diff(0)
          puts curr_light.tag.visible_files.first if DEBUG
          @compile = s.compiles.create(light_color: curr_light.colour.to_s, git_tag: curr_light.number.to_s)
        end
        s.red_light_count = @redlights
        s.green_light_count = @greenlights
        s.amber_light_count = @amberlights
        s.max_consecutive_red_chain_length = maxRedString
        calc_sloc
        s.total_sloc_count = @sloc
        s.production_sloc_count = @production_loc
        s.test_sloc_count = @test_loc

        s.cumulative_test_run_count = @runtests
        s.cumulative_test_fail_count = @runtestfails
        #DO YOUR THiNG
        #s.final_number_tests = XX

        s.save

        #@compile = session.compiles.create(light_color: 'NO_COLOR')
      end
    end
    if(i > 4)
      break
    end
  end
end

def expectation(compile, phase)

  case phase.tdd_color
  when 'red'
    unless compile.light_color == 'green' && compile.

        end
    #when 'green'
    #when 'blue'
  end

end

def calc_cycles
  pos = 0
  prev_outer = nil
  prev_cycle_end = nil
  test_change = false
  prod_change = false
  in_cycle = false
  cycle = ""
  cycle_lights = Array.new
  cycle_test_edits = 0
  cycle_code_edits = 0
  cycle_total_edits = 0
  cycle_test_change = 0
  cycle_code_change = 0
  cycle_reds = 0
  cycle_time = 0
  first_cycle = true

  #Get Session
  curr_session = Session.where(cyberdojo_id: @kata.id, avatar: @avatar.name)
  puts "DEBUG: #{curr_session[0]}" if DEBUG
  curr_session = curr_session[0]

  #New Cycle
  curr_cycle = Cycle.new(cycle_position: pos)

  #New Phase
  curr_phase = Phase.new(tdd_color: 'red')

  #For Each Light
  @avatar.lights.each_with_index do |curr, index|

    #New Compile
    curr_compile = Compile.new

    #Compile Initialization
    curr_compile.test_change = false
    curr_compile.prod_change = false
    curr_compile.light_color = curr.colour
    curr_compile.git_tag = curr.number

    #Aquire file changes from light
    if index == 0
      diff = @avatar.tags[0].diff(index)
      curr_compile.test_change = true
    else
      diff = @avatar.tags[index - 1].diff(index)
    end

    #Check for changes to Test or Prod code
    diff.each do |filename, content|
      non_code_filenames = ['output', 'cyber-dojo.sh', 'instructions']
      unless non_code_filenames.include?(filename)
        if content.count { |line| line[:type] === :added } > 0 || content.count { |line| line[:type] === :deleted } > 0
          #Check if file is a Test
          if (filename.include?"Test") || (filename.include?"test") || (filename.include?"Spec") || (filename.include?"spec") || (filename.include?".t") || (filename.include?"Step") || (filename.include?"step")
            curr_compile.test_change = true
          else
            curr_compile.prod_change = true
          end
        end
      end
    end #End of Diff For Each

    #Count Lines Modified
    if index == 0 #If no previous light in this cycle use the last cycle's end
      test_edits, code_edits = calc_lines(nil, curr)
    else
      test_edits, code_edits = calc_lines(@avatar.lights[index - 1], curr)
    end

    #Store Lines to Model
    curr_compile.test_edited_line_count = test_edits
    curr_compile.production_edited_line_count = code_edits
    curr_compile.total_edited_line_count = test_edits + code_edits

    #Determine Time Spent
    if index == 0 #If the first light of the Kata
      time_diff = curr.time - @start_date
    else
      time_diff = curr.time - @avatar.lights[index - 1].time
    end

    #Drop Time if it hits the Time Ceiling
    if time_diff > @TIME_CEILING
      time_diff = 0
    end

    #Store Time to Model
    curr_compile.seconds_since_last_light = time_diff

    #################################
    #TODO: Count test methods in light
    #################################
    curr_compile.total_test_method_count = 0

    #Count Failed Tests
    if index == 0
      runtests, runtestfails = count_fails(nil, curr)
    else
      runtests, runtestfails = count_fails(@avatar.lights[index - 1], curr)
    end
    curr_compile.total_test_run_count = runtests
    curr_compile.total_test_run_fail_count = runtestfails

    #################################
    #TODO: Coverage, Total SLOC, Prod SLOC, Test SLOC
    #################################

    #NEW LOGIC ============================
    case evaluation(curr_compile)
    when 'red'
    when 'green'
    when 'blue'
    else
    end


    #LOGIC ================================
    if expectation(curr_compile, curr_phase)
      curr_compile.phase_id = curr_phase.id
      curr_compile.save
      if curr_phase.tdd_color == 'green' && curr_compile.light_color == 'green'
        #New Phase (Blue)
        curr_phase.save
        curr_phase = Phase.new(tdd_color = 'blue')
      end
      #Expectation Not Met: Current compile was not a refactor, so push as red
    elsif curr_phase.tdd_color == 'blue'
      #A refactor phase occurred
      unless curr_phase.compiles.empty?
        curr_phase.cycle_id = curr_cycle.id
        curr_phase = Phase.new(tdd_color: red)
      else
        curr_phase.tdd_color == 'red'

      end
      #End the Cycle
      pos += 1
      curr_cycle.session_id = curr_session.id
      curr_cycle = Cycle.new(cycle_position: pos)

    end

    ##    #Green indicates end of cycle, also process if at last light
    ##    if curr.colour.to_s == "green" || index == @avatar.lights.count - 1

    ##      #Determine the type of cycle
    ##      if (test_change && !prod_change) || (!test_change && prod_change) || (!test_change && !prod_change)
    ##        cycle = "R" #Refactor if changes are exclusive to production or test files
    ##      else
    ##        if in_cycle == true && curr.colour.to_s == "green"
    ##          cycle = "TP" #Test-Prod
    ##        else
    ##          cycle = "R"
    ##        end
    ##      end

    ##    #Total Lines Modified in Cycle
    ##    cycle_test_edits += test_edits
    ##    cycle_code_edits += code_edits

    ##    #Total Lines Modified in Kata
    ##    @edited_lines += test_edits
    ##    @edited_lines += code_edits
    ##    light_edits = code_edits + test_edits
    ##    cycle_total_edits += light_edits

    ##      prev = nil
    ##      #Process Metrics & Output Data
    ##      cycle_lights.each_with_index do |light, light_index|

    ##        #Increment Time
    ##        @total_time += time_diff
    ##        cycle_time += time_diff

    ##        #Count Types of Lights
    ##        case light.colour.to_s
    ##        when "red"
    ##          @redlights += 1
    ##          cycle_reds += 1
    ##        when "green"
    ##          @greenlights += 1
    ##        when "amber"
    ##          @amberlights += 1
    ##        end

    ##        #Eliminate Unsupported Stats
    ##        unless @supp_test_langs.include?@language
    ##          light_edits = "NA"
    ##          test_edits = "NA"
    ##          code_edits = "NA"
    ##        end

    ##        #Assign current light to previous
    ##        prev = light
    ##      end #End of For Each

    #Eliminate Unsupported Stats
    unless @supp_test_langs.include?@language
      cycle_total_edits = "NA"
      cycle_test_edits = "NA"
      cycle_code_edits = "NA"
      cycle_test_change = "NA"
      cycle_code_change = "NA"
    end

    ##      #If this was a TP Cycle then process it accordingly
    ##      if cycle == "TP"
    ##        #Set consecutive reds if new maximum
    ##        if cycle_reds > @consecutive_reds
    ##          @consecutive_reds = cycle_reds
    ##        end
    ##        #Count changes to Test and Code from diff of entire cycle
    ##        cycle_test_change, cycle_code_change = calc_lines(prev_cycle_end, curr)
    ##      end

    #Save to DB
    curr_cycle.session_id = curr_session[0].id
    curr_cycle.save

    #Reset Phase Metrics
    test_change = false
    prod_change = false
    in_cycle = false
    cycle_test_change = 0
    cycle_code_change = 0
    cycle_test_edits = 0
    cycle_code_edits = 0
    cycle_total_edits = 0
    cycle_time = 0
    cycle_reds = 0
    cycle_lights.clear

    pos += 1
    prev_cycle_end = curr

    ##      #New Cycle
    ##      curr_cycle = Cycle.new(cycle_position: pos)

    ##    elsif curr.colour.to_s == "red"
    ##      in_cycle = true
    ##      if (test_change && !prod_change)

    ##      end
    ##    end #End of "If Green"

    ##    prev_outer = curr

  end #End of For Each Light

  #END OF SESSION METRICS

  #Final Test Number
  count_tests
  curr_session.final_test_method_count = @totaltests

  #Determine if Kata Ends on Green
  if @avatar.lights[@avatar.lights.count - 1].colour.to_s == "green"
    @ends_green = 1
  else
    @ends_green = 0
  end

end

def count_fails(prev, curr)

  runtests = 0
  runtestfails = 0

  #Take Diff
  if prev.nil? #If no previous light use the beginning
    diff = @avatar.tags[0].diff(curr.number)
  else
    diff = @avatar.tags[prev.number].diff(curr.number)
  end

  diff.each do |filename, content|
    if filename.include?"output"
      content.each do |line|

        case @language.to_s
        when "Java-1.8_JUnit"
          re = /\{:type=>:(added|same), :line=>\"Tests run: (?<tests>\d+),  Failures: (?<fails>\d+)\", :number=>\d+\}/
          result = re.match(line.to_s)

          unless result.nil?
            runtests += result['tests'].to_i
            runtestfails += result['fails'].to_i
          end
        end
      end
    end
  end

  return runtests, runtestfails
end

#TODO: Rewrite count_tests to work on diffs
def count_tests
  Dir.entries(@path.to_s + "sandbox").each do |currFile|
    isFile = currFile.to_s =~ /\.java$|\.py$|\.c$|\.cpp$|\.js$|\.php$|\.rb$|\.hs$|\.clj$|\.go$|\.scala$|\.coffee$|\.cs$|\.groovy$\.erl$/i

    unless isFile.nil?
      file = @path.to_s + "sandbox/" + currFile.to_s
      begin
        case @language.to_s
        when "Java-1.8_JUnit"
          if File.open(file).read.scan(/junit/).count > 0
            @totaltests += File.open(file).read.scan(/@Test/).count
          end
        when "Java-1.8_Mockito"
          if File.open(file).read.scan(/org\.mockito/).count > 0
            @totaltests += File.open(file).read.scan(/@Test/).count
          end
        when "Java-1.8_Powermockito"
          if File.open(file).read.scan(/org\.powermock/).count > 0
            @totaltests += File.open(file).read.scan(/@Test/).count
          end
        when "Java-1.8_Approval"
          if File.open(file).read.scan(/org\.approvaltests/).count > 0
            @totaltests += File.open(file).read.scan(/@Test/).count
          end
        when "Python-unittest"
          if File.open(file).read.scan(/unittest/).count > 0
            @totaltests += File.open(file).read.scan(/def /).count
          end
        when "Python-pytest"
          if file.include?"test"
            @totaltests += File.open(file).read.scan(/def /).count
          end
        when "Ruby-TestUnit"
          if File.open(file).read.scan(/test\/unit/).count > 0
            @totaltests += File.open(file).read.scan(/def /).count
          end
        when "Ruby-Rspec"
          if File.open(file).read.scan(/describe/).count > 0
            @totaltests += File.open(file).read.scan(/it /).count
          end
        when "C++-assert"
          if File.open(file).read.scan(/cassert/).count > 0
            @totaltests += File.open(file).read.scan(/static void /).count
          end
        when "C++-GoogleTest"
          if File.open(file).read.scan(/gtest\.h/).count > 0
            @totaltests += File.open(file).read.scan(/TEST\(/).count
          end
        when "C++-CppUTest"
          if File.open(file).read.scan(/CppUTest/).count > 0
            @totaltests += File.open(file).read.scan(/TEST\(/).count
          end
        when "C++-Catch"
          if File.open(file).read.scan(/catch\.hpp/).count > 0
            @totaltests += File.open(file).read.scan(/TEST_CASE\(/).count
          end
        when "C-assert"
          if File.open(file).read.scan(/assert\.h/).count > 0
            @totaltests += File.open(file).read.scan(/static void /).count
          end
        when "Go-testing"
          if File.open(file).read.scan(/testing/).count > 0
            @totaltests += File.open(file).read.scan(/func /).count
          end
        when "Javascript-assert"
          if File.open(file).read.scan(/assert/).count > 0
            @totaltests += File.open(file).read.scan(/assert/).count - 2 #2 extra because of library include line
          end
        when "C#-NUnit"
          if File.open(file).read.scan(/NUnit\.Framework/).count > 0
            @totaltests += File.open(file).read.scan(/\[Test\]/).count
          end
        when "PHP-PHPUnit"
          if File.open(file).read.scan(/PHPUnit_Framework_TestCase/).count > 0
            @totaltests += File.open(file).read.scan(/function /).count
          end
        when "Perl-TestSimple"
          if File.open(file).read.scan(/use Test/).count > 0
            @totaltests += File.open(file).read.scan(/is/).count
          end
        when "CoffeeScript-jasmine"
          if File.open(file).read.scan(/jasmine-node/).count > 0
            @totaltests += File.open(file).read.scan(/it/).count
          end
        when "Erlang-eunit"
          if File.open(file).read.scan(/eunit\.hrl/).count > 0
            @totaltests += File.open(file).read.scan(/test\(\)/).count
          end
        when "Haskell-hunit"
          if File.open(file).read.scan(/Test\.HUnit/).count > 0
            @totaltests += File.open(file).read.scan(/TestCase/).count
          end
        when "Scala-scalatest"
          if File.open(file).read.scan(/org\.scalatest/).count > 0
            @totaltests += File.open(file).read.scan(/test\(/).count
          end
        when "Clojure-.test"
          if File.open(file).read.scan(/clojure\.test/).count > 0
            @totaltests += File.open(file).read.scan(/deftest/).count
          end
        when "Groovy-JUnit"
          if File.open(file).read.scan(/org\.junit/).count > 0
            @totaltests += File.open(file).read.scan(/@Test/).count
          end
        when "Groovy-Spock"
          if File.open(file).read.scan(/spock\.lang/).count > 0
            @totaltests += File.open(file).read.scan(/def /).count - 1 #1 extra because of object def
          end
        else
          @totaltests = "NA"
        end
      rescue
        puts "Error: Reading in count_tests"
      end
    end
  end
end

def calc_lines(prev, curr)
  # determine number of lines changed between lights
  test_count = 0
  code_count = 0
  # regex for identifying edits and recording line_number
  re = /\{:type=>:(added|deleted), .* :number=>(?<line_number>\d+)\}/

  if prev.nil? #If no previous light use the beginning
    diff = @avatar.tags[0].diff(curr.number)
  else
    diff = @avatar.tags[prev.number].diff(curr.number)
  end

  diff.each do |filename,lines|

    is_test = false
    line_counted = Array.new
    isFile = filename.match(/\.java$|\.py$|\.c$|\.cpp$|\.js$|\.php$|\.rb$|\.hs$|\.clj$|\.go$|\.scala$|\.coffee$|\.cs$|\.groovy$\.erl$/i)

    unless isFile.nil? || deleted_file(lines) || new_file(lines)
      lines.each do |line|
        begin
          case @language.to_s
          when "Java-1.8_JUnit"
            is_test = true if /junit/.match(line.to_s)
          when "Java-1.8_Mockito"
            is_test = true if /org\.mockito/.match(line.to_s)
          when "Java-1.8_Powermockito"
            is_test = true if /org\.powermock/.match(line.to_s)
          when "Java-1.8_Approval"
            is_test = true if /org\.approvaltests/.match(line.to_s)
          when "Python-unittest"
            is_test = true if /unittest/.match(line.to_s)
          when "Python-pytest"
            is_test = true if filename.include?"test"
          when "Ruby-TestUnit"
            is_test = true if /test\/unit/.match(line.to_s)
          when "Ruby-Rspec"
            is_test = true if /describe/.match(line.to_s)
          when "C++-assert"
            is_test = true if /cassert/.match(line.to_s)
          when "C++-GoogleTest"
            is_test = true if /gtest\.h/.match(line.to_s)
          when "C++-CppUTest"
            is_test = true if /CppUTest/.match(line.to_s)
          when "C++-Catch"
            is_test = true if /catch\.hpp/.match(line.to_s)
          when "C-assert"
            is_test = true if /assert\.h/.match(line.to_s)
          when "Go-testing"
            is_test = true if /testing/.match(line.to_s)
          when "Javascript-assert"
            is_test = true if /assert/.match(line.to_s)
          when "C#-NUnit"
            is_test = true if /NUnit\.Framework/.match(line.to_s)
          when "PHP-PHPUnit"
            is_test = true if /PHPUnit_Framework_TestCase/.match(line.to_s)
          when "Perl-TestSimple"
            is_test = true if /use Test/.match(line.to_s)
          when "CoffeeScript-jasmine"
            is_test = true if /jasmine-node/.match(line.to_s)
          when "Erlang-eunit"
            is_test = true if /eunit\.hrl/.match(line.to_s)
          when "Haskell-hunit"
            is_test = true if /Test\.HUnit/.match(line.to_s)
          when "Scala-scalatest"
            is_test = true if /org\.scalatest/.match(line.to_s)
          when "Clojure-.test"
            is_test = true if /clojure\.test/.match(line.to_s)
          when "Groovy-JUnit"
            is_test = true if /org\.junit/.match(line.to_s)
          when "Groovy-Spock"
            is_test = true if /spock\.lang/.match(line.to_s)
          else
            #Language not supported
          end
        rescue
          puts "Error: Reading in calc_lines"
        end

        break if is_test == true
      end #End of Lines For Each

      if NEW_EDIT_COUNT #New way of counting
        lines.each do |line|
          output = re.match(line.to_s)
          unless output.nil?
            unless line_counted.include?output['line_number'].to_i
              line_counted.push(output['line_number'].to_i)
              if is_test
                test_count += 1
              else
                code_count += 1
              end
            end
          end
        end
      else #Old way of counting
        if is_test
          test_count += lines.count { |line| line[:type] === :added }
          test_count += lines.count { |line| line[:type] === :deleted }
        else
          code_count += lines.count { |line| line[:type] === :added }
          code_count += lines.count { |line| line[:type] === :deleted }
        end
      end

    end #End of Unless statment
  end #End of Diff For Each

  return test_count, code_count
end

def deleted_file(lines)
  return lines.all? { |line| line[:type] === :deleted }
end

def new_file(lines)
  return lines.all? { |line| line[:type] === :added }
end

def calc_sloc
  puts "CALC SLOC" if DEBUG
  dataset = {}
  Dir.entries(@path.to_s + "sandbox").each do |currFile|
    isFile = currFile.to_s =~ /\.java$|\.py$|\.c$|\.cpp$|\.js$|\.php$|\.rb$|\.hs$|\.clj$|\.go$|\.scala$|\.coffee$|\.cs$|\.groovy$\.erl$/i
    puts "isFile" if DEBUG
    puts isFile if DEBUG
    unless isFile.nil?
      file = @path.to_s + "sandbox/" + currFile.to_s
      command = `./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}`
      puts "./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}" if DEBUG
      puts `pwd` if DEBUG
      puts command if DEBUG
      csv = CSV.parse(command)
      puts csv.to_s if DEBUG
      unless(csv.inspect() == "[]")
        if @language.to_s == "Java-1.8_JUnit"
          begin
            if File.open(file).read.scan(/junit/).count > 0
              @test_loc = @test_loc + csv[2][4].to_i
              puts "TEST SLOC" if DEBUG
              puts @test_loc if DEBUG
            else
              @production_loc = @production_loc + csv[2][4].to_i
              puts "PRODUCTION SLOC" if DEBUG
              puts @production_loc if DEBUG
            end
          rescue
            puts "Error: Reading in calc_sloc"
          end
        end
        @sloc = @sloc + csv[2][4].to_i
      end
    end
  end
end

import_all_katas
build_cycle_data
