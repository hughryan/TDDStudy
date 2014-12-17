class MarkupAssignment < ActiveRecord::Base
	belongs_to :researcher
	has_one :session
end