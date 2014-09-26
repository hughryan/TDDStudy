class Session < ActiveRecord::Base
  has_many :cycles
  has_many :phases, :through => :cycles
  has_many :compiles, :through => :phases
end
