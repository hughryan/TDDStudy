task :calc_cycles do
  calc_cycles
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


CYCLE_DIAG = true
ALLOWED_LANGS = Set["Java-1.8_JUnit"]


def root_path
  Rails.root.to_s + '/'
end



def calc_cycles

  #CLEAN OUT OLD RESULTS
  Cycle.delete_all
  Phase.delete_all

  #   SELECT *,s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s
  # LEFT OUTER JOIN interrater_sessions as i on i.session_id = s.id
  #  LEFT OUTER JOIN markup_assignments as m on m.session_id = s.id
  # WHERE i.session_id = s.id OR m.session_id = s.id

  #SELECT KATAS WE WANT TO COMPUTE CYCLES
  # Session.find_by_sql("SELECT s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s
  # INNER JOIN interrater_sessions as i on i.session_id = s.id").each do |session_id|

  # Session.find_by_sql("SELECT s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s
  # INNER JOIN markup_assignments as m on m.session_id = s.id").each do |session_id|

  Session.find_by_sql("SELECT *,s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s
	LEFT OUTER JOIN interrater_sessions as i on i.session_id = s.id
 	LEFT OUTER JOIN markup_assignments as m on m.session_id = s.id
	WHERE i.session_id = s.id OR m.session_id = s.id").each do |session_id|

    # Session.find_by_sql("SELECT s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s WHERE s.id = 4357").each do |session_id|




    puts "CURR SESSION ID: " + session_id.id.to_s if CYCLE_DIAG

    #Setup inital values for each session
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
    curr_num_tests = 0
    new_test = false
    valid_red = false
    started_kata = false

    Session.where("id = ?", session_id.id).find_each do |curr_session|

      puts "CYCLE_DIAG: #{curr_session[0]}" if CYCLE_DIAG

      #New Cycle
      curr_cycle = Cycle.new(cycle_position: pos)

      #New Phase
      curr_phase = Phase.new(tdd_color: "red")

      last_light_color = "red"
      #For Each Light
      curr_session.compiles.each_with_index do |curr_compile, index|
        new_test = false

        ##TODO: introduce case for first compile situations

        if !started_kata
          curr_num_tests = curr_compile.total_assert_count
          puts "FIRST KATA"
          puts "curr_compile.test_change: "+curr_compile.test_change.to_s
          puts "curr_compile.prod_change: "+curr_compile.prod_change.to_s
          puts "curr_compile.light_color: "+curr_compile.light_color.to_s
          puts "curr_compile: "+ curr_compile.inspect

          if !curr_compile.test_change && !curr_compile.prod_change
            curr_phase.tdd_color = "red"
            curr_phase.compiles << curr_compile
            curr_compile.save
            puts "Saved curr_compile to current phase" if CYCLE_DIAG
            started_kata = true
            valid_red = true

          elsif !curr_compile.test_change && curr_compile.prod_change

            if curr_compile.light_color == "green"
              curr_phase.tdd_color = "green"
              curr_phase.compiles << curr_compile
              curr_compile.save
              curr_cycle.phases << curr_phase
              curr_phase.save

              #next phase (assume the next phase is blue)
              curr_phase = Phase.new(tdd_color: "blue")

              puts "Saved curr_compile as green phase" if CYCLE_DIAG
              started_kata = true

            else
              curr_phase.tdd_color = "green"
              curr_phase.compiles << curr_compile
              curr_compile.save
              curr_cycle.phases << curr_phase

            end

          elsif curr_compile.test_change && !curr_compile.prod_change
            curr_phase.tdd_color = "red"
            curr_phase.compiles << curr_compile
            curr_compile.save
            curr_cycle.valid_tdd = false
            valid_red = true
            started_kata = true

          else #indicates both changes

            curr_phase.tdd_color = "white"
            curr_phase.compiles << curr_compile
            curr_compile.save
            curr_cycle.valid_tdd = false

            started_kata = true

          end
          last_light_color = curr_compile.light_color.to_s
        else
          #check for new test in compiles
          if !curr_compile.total_assert_count.nil?
            if curr_compile.total_assert_count > curr_num_tests
              new_test = true
              curr_num_tests = curr_compile.total_assert_count
            elsif curr_compile.total_assert_count < curr_num_tests
              curr_num_tests = curr_compile.total_assert_count
            end
          end
          puts "CYCLE_DIAG CURR: #{curr_compile}" if CYCLE_DIAG
          puts "CYCLE_DIAG INDEX: #{index}" if CYCLE_DIAG


          puts "*************" if CYCLE_DIAG
          puts "{" if CYCLE_DIAG
          puts "Light color: " + curr_compile.light_color.to_s if CYCLE_DIAG
          puts "Test edit: " + curr_compile.test_change.to_s if CYCLE_DIAG
          puts "Production edit: " + curr_compile.prod_change.to_s if CYCLE_DIAG

          puts "Current Phase: " + curr_phase.tdd_color.to_s if CYCLE_DIAG
          puts "Current Phase Empty?: " + curr_phase.compiles.empty?.to_s if CYCLE_DIAG
          puts "New Test?: " + new_test.to_s if CYCLE_DIAG
          puts "valid red?: " + valid_red.to_s if CYCLE_DIAG

          #Add some better situational awareness about cycles and phases
          puts "########## curr_cycle ##########"
          # puts curr_cycle.inspect
          if(curr_cycle.id == nil)
            puts "NULL CYCLE"
          else
            puts "CurrCycle.id:" + curr_cycle.id.to_s
            puts "CurrCycle.session_id:" + curr_cycle.session_id.to_s
            puts "CurrCycle.session_id:" + curr_cycle.session_id.to_s
            curr_cycle.phases.each do |phase|
              phase.inspect
            end
          end
          puts "&&&&&&&&& curr_phase &&&&&&&&&&"
          puts curr_phase.inspect
          puts "curr_phase.id: " + curr_phase.id.to_s
          puts "curr_phase.tdd_color: " + curr_phase.tdd_color.to_s
          curr_phase.compiles.each do |compile|
            puts "compile.git_tag: "+ compile.git_tag.to_s
            puts "compile.light_color: "+ compile.light_color.to_s

          end

          puts "LAST LIGHT COLOR: "+last_light_color
          #check for empty compile (no edits)
          if !curr_compile.test_change && !curr_compile.prod_change && (last_light_color == curr_compile.light_color.to_s)
            curr_phase.compiles << curr_compile
            curr_compile.save
            puts "Saved curr_compile to current phase" if CYCLE_DIAG
          else
            puts "%%%%%%%%%%%  Start CASE  %%%%%%%%%%%"
            #cycle logic
            case curr_phase.tdd_color

            when "red"

              #check for new test in red phase, if there is one mark this as a valid red phase
              if new_test
                valid_red = true
              end

              if curr_compile.light_color.to_s == "red" || curr_compile.light_color.to_s == "amber"

                if curr_compile.test_change && !curr_compile.prod_change
                  curr_phase.compiles << curr_compile
                  curr_compile.save
                  puts "Saved curr_compile to red phase(1)" if CYCLE_DIAG

                elsif curr_compile.test_change && curr_compile.prod_change

                  if valid_red
                    #save phase before new curr_compile is added
                    curr_cycle.phases << curr_phase
                    curr_phase.save

                    #EXPERIMENTING
                    # puts "Start Green Phase (both test and production changes and red or amber compile)" if CYCLE_DIAG
                    # curr_phase = Phase.new(tdd_color: "green")

                    # #new curr_compile is part of next phase, so save now
                    # puts "Saved curr_compile to green phase" if CYCLE_DIAG
                    # curr_phase.compiles << curr_compile
                    # curr_compile.save

                    puts "[!1!] NON - TDD >> no new test and production edits occured" if CYCLE_DIAG

                    #NON TDD (no red phase occured)
                    curr_phase = Phase.new(tdd_color: "green")
                    curr_cycle.valid_tdd = false
                    curr_phase.tdd_color = "white"

                    #save curr_compile to phase
                    curr_phase.compiles << curr_compile
                    curr_compile.save
                  else
                    puts "[!1!] NON - TDD >> no new test and production edits occured" if CYCLE_DIAG

                    #NON TDD (no red phase occured)
                    curr_cycle.valid_tdd = false
                    curr_phase.tdd_color = "white"

                    #save curr_compile to phase
                    curr_phase.compiles << curr_compile
                    curr_compile.save
                  end
                  #reset new_test
                  valid_red = false

                else #only prod edits in red phase SHOULD indicate on to green

                  if valid_red
                    #save phase before new curr_compile is added
                    curr_cycle.phases << curr_phase
                    curr_phase.save

                    puts "Start Green Phase (only production changes and red or amber compile)" if CYCLE_DIAG
                    curr_phase = Phase.new(tdd_color: "green")

                    #new curr_compile is part of next phase, so save now
                    puts "Saved curr_compile to green phase" if CYCLE_DIAG
                    curr_phase.compiles << curr_compile
                  else
                    puts "[!2!] NON - TDD >> no new test for testing phase" if CYCLE_DIAG

                    #NON TDD (no red phase occured)
                    curr_cycle.valid_tdd = false
                    curr_phase.tdd_color = "white"

                    #save curr_compile to phase
                    curr_phase.compiles << curr_compile
                    curr_compile.save
                  end
                  #reset valid red marker
                  valid_red = false

                end

              else #green curr_compile with valid_red indicates green phase

                if valid_red
                  #save phase before new curr_compile is added
                  curr_cycle.phases << curr_phase
                  curr_phase.save

                  puts "Start Green Phase (green compile during valid red phase)" if CYCLE_DIAG
                  curr_phase = Phase.new(tdd_color: "green")

                  #new curr_compile is part of next phase, so save now
                  puts "Saved curr_compile to green phase and end green phase" if CYCLE_DIAG
                  curr_phase.compiles << curr_compile
                  curr_phase.save

                  #save phase since green phase was over in one compile
                  curr_cycle.phases << curr_phase
                  curr_phase.save

                  #on to blue
                  puts "Start Blue Phase" if CYCLE_DIAG
                  curr_phase = Phase.new(tdd_color: "blue")

                elsif curr_compile.test_change && !curr_compile.prod_change
                  curr_phase.compiles << curr_compile
                  curr_compile.save
                  puts "Saved curr_compile to red phase(2)" if CYCLE_DIAG

                else
                  puts "[!3!] NON - TDD >> production edits in testing phase" if CYCLE_DIAG

                  #NON TDD (no red phase occured)
                  curr_cycle.valid_tdd = false
                  curr_phase.tdd_color = "white"

                  #save curr_compile to phase
                  curr_phase.compiles << curr_compile
                  curr_compile.save

                end
                #reset new_test
                valid_red = false
              end

            when "green"

              if curr_compile.light_color.to_s == "red" ||  curr_compile.light_color.to_s == "amber"
                if !new_test
                  #save curr_compile to phase
                  curr_phase.compiles << curr_compile
                  curr_compile.save

                else
                  puts "[!4!] NON - TDD >> new test in green phase!" if CYCLE_DIAG

                  #NON TDD (no red phase occured)
                  curr_cycle.valid_tdd = false
                  curr_phase.tdd_color = "white"

                  #save curr_compile to phase
                  curr_phase.compiles << curr_compile
                  curr_compile.save

                end

              else #green curr_compile indicates the green phase has ended, move on to refactor (or test if need be)

                if !new_test
                  #save curr_compile to phase and phase to cycle
                  curr_phase.compiles << curr_compile
                  curr_compile.save
                  curr_cycle.phases << curr_phase
                  curr_phase.save

                  puts "Saved curr_compile to green phase" if CYCLE_DIAG
                  puts "Exit Green Phase" if CYCLE_DIAG
                  puts "Start Blue phase" if CYCLE_DIAG

                  #next phase (assume the next phase is blue)
                  curr_phase = Phase.new(tdd_color: "blue")

                else
                  puts "[!5!] NON - TDD >> new test in green phase!" if CYCLE_DIAG

                  #NON TDD (no red phase occured)
                  curr_cycle.valid_tdd = false
                  curr_phase.tdd_color = "white"

                  #save curr_compile to phase
                  curr_phase.compiles << curr_compile
                  curr_compile.save

                end

              end

            when "blue"

              if (curr_compile.light_color.to_s == "red" ||  curr_compile.light_color.to_s == "amber") && new_test
                #save phase to cycle, save cycle to session
                if  curr_phase.compiles.length > 0
                  curr_cycle.phases << curr_phase
                  curr_phase.save
                end

                curr_session.cycles << curr_cycle
                curr_cycle.valid_tdd = true
                curr_cycle.save

                #new cycle, phase
                pos += 1 #cycle position
                curr_phase = Phase.new(tdd_color: "red")
                curr_cycle = Cycle.new(cycle_position: pos)
                #save current compile
                curr_phase.compiles << curr_compile
                curr_compile.save
                #set valid red
                valid_red = true
                puts "Saved curr_compile to red phase(3)" if CYCLE_DIAG

              else #curr_compile is green, red or amber without a new test

                if !new_test

                  #save curr_compile to phase
                  curr_phase.compiles << curr_compile
                  curr_compile.save
                  puts "Saved curr_compile to blue phase" if CYCLE_DIAG

                else
                  #if they are doing tdd there will only be test edits in the brown phase
                  if curr_compile.test_change && !curr_compile.prod_change
                    #if not empty, save current blue phase.
                    if  curr_phase.compiles.length > 0
                      curr_cycle.phases << curr_phase
                      curr_phase.save
                      curr_phase = Phase.new(tdd_color: "brown")
                    end

                    puts "BROWN PHASE"
                    curr_phase.tdd_color = "brown"
                    curr_phase.compiles << curr_compile
                    curr_cycle.phases << curr_phase
                    curr_compile.save
                    curr_phase.save


                    puts "Start Green Phase (only production changes and red or amber compile)" if CYCLE_DIAG
                    curr_phase = Phase.new(tdd_color: "blue")
                  else  #if they are changeing multiple files, its not valid TDD
                    puts "[!6!] NON - TDD >> new test in blue phase!" if CYCLE_DIAG
                    #NON TDD (no red phase occured)
                    curr_phase.tdd_color = "white"
                    #save curr_compile to phase
                    curr_phase.compiles << curr_compile
                    curr_compile.save

                  end

                end

              end

            when "white"

              if curr_compile.light_color.to_s == "red" || curr_compile.light_color.to_s == "amber"

                if curr_compile.test_change && !curr_compile.prod_change && new_test

                  pos += 1
                  curr_cycle.phases << curr_phase
                  curr_phase.save
                  curr_session.cycles << curr_cycle
                  curr_cycle.save
                  curr_cycle.valid_tdd = false
                  puts "Exit white phase" if CYCLE_DIAG
                  curr_phase = Phase.new(tdd_color: "red")
                  curr_cycle = Cycle.new(cycle_position: pos)
                  curr_phase.compiles << curr_compile
                  curr_compile.save
                  valid_red = true
                else
                  #save curr_compile to phase
                  curr_phase.compiles << curr_compile
                  curr_compile.save
                  puts "Inside white phase" if CYCLE_DIAG
                end
              else

                #save curr_compile to phase
                curr_phase.compiles << curr_compile
                curr_compile.save
                puts "Inside white phase" if CYCLE_DIAG

              end

            end #end of cycle logic
            last_light_color = curr_compile.light_color.to_s

          end #end of if else

        end #end of if started kata
        puts "}" if CYCLE_DIAG
        puts "*************" if CYCLE_DIAG


      end #End of For Each Light

      #check if the last cycle finished
      if curr_phase.tdd_color == "blue"
        curr_cycle.valid_tdd = true
      end

      curr_cycle.phases << curr_phase
      curr_session.cycles << curr_cycle
      curr_phase.save
      curr_cycle.save

    end # end of for all sessions
  end

end
