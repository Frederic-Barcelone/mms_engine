class CopyrightHolder < ActiveRecord::Base
  attr_accessible :title, :website
  validates_presence_of :title
  has_many :copyrights
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: copyright_holders
#
#  id      :integer(4)      not null, primary key
#  title   :string(250)     not null
#  website :string(255)