 # Gibbon::API.api_key = ENV["MAILCHIMP_API_KEY"]
 debugger
Gibbon::Request.api_key = ENV["MAILCHIMP_API_KEY"]
Gibbon::Request.timeout = 15
Gibbon::Request.throws_exceptions = true
#puts "MailChimp API key: #{Gibbon::Request.api_key}" # temporary

# Gibbon::Request.api_key = "your_api_key"
# Gibbon::Request.timeout = 15
# Gibbon::Request.open_timeout = 15
# Gibbon::Request.symbolize_keys = true
# Gibbon::Request.debug = false