class Attachment < ApplicationRecord
	belongs_to :attachable, polymorphic: true
	has_attached_file :attachment, styles: {thumb: "100x100"}
	validates_attachment_content_type :attachment, content_type: ["image/jpeg", "image/jpg", "image/png", "image/gif","application/pdf"]
end
