class Session < ActiveRecord::Base
	has_many :cycles
	has_many :compiles
end
