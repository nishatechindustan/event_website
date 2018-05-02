class SearchsController < ApplicationController
	def index
		@events = Event.search(params)
		@states = State.all.order("name ASC").map(&:name)
		@categories = Category.all.order("name ASC").map{|a| [a.name, a.id]}
	end
end
