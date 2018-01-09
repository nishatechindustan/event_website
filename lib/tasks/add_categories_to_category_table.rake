namespace :add_categories do
desc "Adding categories to Category table"
task :to_category => :environment do
	categories = [{name: 'New Year Special'},
					{name: 'Merry Christmas'},
					{name: 'Halloween'},
					{name: 'The Music Room - Farewell Edition'},
					{name: 'Deepawali - "Festival of lights"'},
					{name: 'Grand Prix 2017'},
					{name: 'Ladies Night'},
					{name: 'Brunch Special'},
					{name: 'Festive Special'},
					{name: 'Bars/Lounges/Cuisines'},
					{name: 'Sports/Races'},
					{name: 'Family / Kids'},
					{name: 'Comedy'},
					{name: 'Parties / Clubbing'},
					{name: 'Community Services'},
					{name: 'Live Shows / Concerts / Movies'},
					{name: 'Fitness / Recreational / Meditation'},
					{name: 'Art fests/ Art shows/Street shows'},
					{name: 'Regional Events / Fests	'},
					{name: 'MICE - Meetings, incentives, conferences, and exhibitions'}
				]
	categories.each do |category|
		Category.create(category)
	end			
end  
end