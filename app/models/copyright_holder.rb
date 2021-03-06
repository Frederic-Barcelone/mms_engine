# == Schema Information
#
# Table name: copyright_holders
#
#  id      :integer          not null, primary key
#  title   :string(250)      not null
#  website :string(255)
#

class CopyrightHolder < ActiveRecord::Base
  attr_accessible :title, :website
  validates_presence_of :title
  has_many :copyrights
end