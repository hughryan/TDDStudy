class Session < ActiveRecord::Base
	has_many :cycles
	# has_many :phases, :through => :cycles
	#has_many :compiles, :through => :phases
	has_many :compiles
	has_many :markups
end
