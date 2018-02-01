namespace :add_artists do
desc "Adding artist to Artist table"
task :to_artist => :environment do
	artists = [{name: 'A R Rahman'},
					{name: 'Hema'},
					{name: 'hony'},
					{name: 'Ashish'},
					{name: "Alok"}
				]
	artists.each do |artist|
		Artist.create(artist)
	end
end
end
