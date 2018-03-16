class Attachment < ApplicationRecord
	belongs_to :attachable, polymorphic: true
	#attr_accessor :image_base
	#before_validation :parse_image

	has_attached_file :attachment, path: ':rails_root/public/assets/:class/:attachment/:id_partition/:style/:filename',
 		styles: {thumb: "100x100"}
	validates_attachment_content_type :attachment, content_type: ["image/jpeg", "image/jpg", "image/png", "image/gif"]
	# ":rails_root/public/system/:rails_env/:class/:attachment/:id_partition/:filename"
	# private
	#  def parse_image
	# 	 image = Paperclip.io_adapters.for(image_base) image.original_filename = "file.jpg"
	# 	  self.picture = image
	#  end
end
#'my/secret/folder/:class/:attachment/:id_partition/:style/:filename'