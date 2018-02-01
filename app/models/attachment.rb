class Attachment < ApplicationRecord
	belongs_to :attachable, polymorphic: true
	#attr_accessor :image_base
	#before_validation :parse_image

	has_attached_file :attachment, styles: {thumb: "100x100"}
	validates_attachment_content_type :attachment, content_type: ["image/jpeg", "image/jpg", "image/png", "image/gif","application/pdf"]

	# private
	#  def parse_image
	# 	 image = Paperclip.io_adapters.for(image_base) image.original_filename = "file.jpg"
	# 	  self.picture = image
	#  end
end
