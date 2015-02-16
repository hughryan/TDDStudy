task :find_potential_completed_katas do
  find_potential_completed_katas
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



def find_potential_completed_katas

  Session.find_by_sql("SELECT * FROM sessions
WHERE language_framework LIKE \"Java-1.8_JUnit\"
AND kata_name LIKE \"Fizz_Buzz\"").each do |session|

    puts "(((((((((((((((((( New Session ))))))))))))))))))))"
    puts session.inspect
    puts " "
    puts " "
    session.potential_complete = false
    if session.final_light_color == "green"
      if session.total_sloc_count > 10
        session.potential_complete = true
      end
    end
    session.save
  end
end
