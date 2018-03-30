class Attachment < ApplicationRecord
	belongs_to :attachable, polymorphic: true
	has_attached_file :attachment
	validates_attachment_content_type :attachment, content_type: ["image/jpeg", "image/jpg", "image/png", "image/gif"]
end
