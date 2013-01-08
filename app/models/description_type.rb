class DescriptionType < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :captions  
  has_many :descriptions
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: description_types
#
#  id    :integer(4)      not null, primary key
#  title :string(100)     not null