class Attachment < ApplicationRecord
	belongs_to :attachable, polymorphic: true
	#attr_accessor :image_base
	#before_validation :parse_image

	has_attached_file :attachment, styles: {thumb: "100x100"}
	 # has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>", :small=>"60x60>" },
  #                        :path => ':rails_root/public/system/:class/:id/:style/:filename',
  #                        :url => '/system/:class/:id/:style/:filename'


  # has_attached_file :attachment, :path => ":rails_root/storage/#{Rails.env}/attachments/:id/:style/:basename.:extension",
  #   has_attached_file :attachment, :path => ":rails_root/storage/attachments/:id/:style/:basename.:extension",
  # :url => '/attachments/:class/:id/:style/:filename'

	validates_attachment_content_type :attachment, content_type: ["image/jpeg", "image/jpg", "image/png", "image/gif","application/pdf"]
	
end
