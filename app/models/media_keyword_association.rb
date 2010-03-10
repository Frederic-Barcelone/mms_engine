# == Schema Info
# Schema version: 20100310060934
#
# Table name: media_keyword_associations
#
#  id         :integer(4)      not null, primary key
#  keyword_id :integer(4)      not null
#  medium_id  :integer(4)      not null

class MediaKeywordAssociation < ActiveRecord::Base
  validates_presence_of :medium_id, :keyword_id
  belongs_to  :medium
  belongs_to  :keyword
  
end
