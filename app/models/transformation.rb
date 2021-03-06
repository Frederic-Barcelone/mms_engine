# == Schema Information
#
# Table name: transformations
#
#  id          :integer          not null, primary key
#  renderer_id :integer          not null
#  title       :string(20)       not null
#  path        :string(100)      not null
#

class Transformation < ActiveRecord::Base
  attr_accessible :renderer_id, :title, :path
  belongs_to :renderer, :class_name => 'FileRenderer'
  has_many :typescripts
  
  def full_path
    renderer.path.sub(/:transformation/, path)
  end
end