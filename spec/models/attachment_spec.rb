require 'rails_helper'

RSpec.describe Attachment, type: :model do
 it { should belong_to(:attachable) }
 it { should have_attached_file(:attachment) }
 it { should validate_attachment_content_type(:attachment).
                allowing('image/png', 'image/gif', "image/jpeg", "image/jpg").
                rejecting('text/plain', 'text/xml') }
end
