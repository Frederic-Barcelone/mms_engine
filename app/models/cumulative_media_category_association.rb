class CumulativeMediaCategoryAssociation < ActiveRecord::Base
  belongs_to :medium
  belongs_to :category
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: cumulative_media_category_associations
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)      not null
#  medium_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime