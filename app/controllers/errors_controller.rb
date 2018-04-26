class ErrorsController < ApplicationController
	def error_404
		
		render file: "/public/404.html" , layout: false
	end
end
