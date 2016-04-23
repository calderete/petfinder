require "pry"
require "Nokogiri"
require "HTTParty"
require "csv"
require "JSON"

page = HTTParty.get('https://atlanta.craigslist.org/search/pet?s=0')

parse_page = Nokogiri::HTML(page)

pets_array = []

parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
	post_name = a.text
	pets_array.push(post_name)
end

CSV.open('pets.csv', 'w') do |csv|
	csv << pets_array
end

#Pry.start(binding)