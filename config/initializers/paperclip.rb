# # if Rails.env.development?
# #   Paperclip::Attachment.default_options.merge!(
# #     path: ":rails_root/public/paperclip/:rails_env/:class/:attachment/:id_partition/:filename",
# #     storage: :filesystem
# #   )
# # end

# # if Rails.env.development? || production?
# 	Paperclip::Attachment.default_options.update({
# 	    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:parameterize_file_name",
# 	    :url => "/system/:class/:attachment/:id/:style/:parameterize_file_name",
# 	})

# 	Paperclip.interpolates :parameterize_file_name do |attachment, style|
# 	    sanitize_filename(attachment.original_filename)
# 	end
# # end

# def sanitize_filename(filename)
#     fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
#     fn[0] = fn[0].parameterize
#     return fn.join '.'
# end