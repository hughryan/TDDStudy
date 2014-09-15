class CycleCatagorizerController < ApplicationController
  def cycle_catgories
  	@cycles = Cycle.all
  end

  def parseCSV
  	@filename = '/Users/michaelhilton/Development/TDDStudy/corpus.csv'
  	@CSVRows = SmarterCSV.process(@filename ,{:col_sep => "\|",  :force_simple_split => true })

  	@CSVRows.each do |row|
  		
  		kata = Kata.new do |k|
  			k.cyberdojo_id = row[:kataid]	
		end
  	end

  	#user = User.create(name: "David", occupation: "Code Artist")
  end
end
