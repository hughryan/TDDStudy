class Cycle < ActiveRecord::Base
  belongs_to :session
  has_many :phases
end
