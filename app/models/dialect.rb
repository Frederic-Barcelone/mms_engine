class Dialect < ActiveRecord::Base
  has_many :words
end

# == Schema Info
# Schema version: 20110319012021
#
# Table name: dialects
#
#  id    :integer(4)      not null, primary key
#  title :string(140)     not null