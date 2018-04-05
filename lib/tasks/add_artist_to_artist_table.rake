namespace :add_artists do
desc "Adding artist to Artist table"
task :to_artist => :environment do
	artists = [{name: 'A R Rahman', artist_type: 'Singer'},
					{name: 'Hema', artist_type: 'Singer'},
					{name: 'hony', artist_type: 'Singer'},
					{name: 'Ashish', artist_type: 'Dancer'},
					{name: "Alok", artist_type: 'Dancer'}
				]
	artists.each do |artist|
		Artist.create(artist)
	end
end
end
