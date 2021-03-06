# == Schema Information
#
# Table name: media
#
#  id                       :integer          not null, primary key
#  photographer_id          :integer
#  quality_type_id          :integer
#  created_on               :datetime
#  updated_on               :datetime
#  recording_note           :text
#  private_note             :text
#  type                     :string(10)       not null
#  attachment_id            :integer
#  taken_on                 :datetime
#  recording_orientation_id :integer
#  capture_device_model_id  :integer
#  partial_taken_on         :string(255)
#  application_filter_id    :integer          not null
#  resource_type_id         :integer          not null
#  rotation                 :integer
#

class Document < Medium
  attr_accessible :typescript, :recording_note, :resource_type_id, :photographer_id, :taken_on,
    :capture_device_model_id, :quality_type_id, :private_note
  
  include MediaProcessor::DocumentExtension
  
  before_create  { |record| record.resource_type_id = 2639 if record.resource_type_id.nil? }
  before_destroy { |record| record.typescript.destroy if !record.typescript.nil? }
  
  # The preview is generated in the highest possible resolution.  
  PREVIEW_TYPE = :huge
  belongs_to :typescript, :foreign_key => 'attachment_id'
  
  def attachment
    typescript
  end
    
  def self.public_folder
    'typescripts'
  end
  
  def prioritized_title
    titles = self.titles.order(:id)
    return titles.empty? ? self.id.to_s : titles.first.title
  end
  
  def preview_image
    typescript = self.typescript
    return typescript.nil? ? nil : typescript.children.where(:thumbnail => PREVIEW_TYPE.to_s).first
  end
    
  def self.paged_media_search(media_search, limit = 10, offset = 0)
    super(media_search, limit, offset, 'Document')
  end
end