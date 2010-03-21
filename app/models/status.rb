class Status < ActiveRecord::Base
  validates_presence_of :title, :position
  has_many :media, :through => :workflows 
end

# == Schema Info
# Schema version: 20100320035754
#
# Table name: statuses
#
#  id          :integer(4)      not null, primary key
#  description :text
#  position    :integer(4)      not null
#  title       :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime