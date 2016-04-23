require "pry"
require "Nokogiri"
require "HTTParty"
require "csv"
require "JSON"

class GetListings

	def initialize
		puts "Which city do you wish to search?"
		city = gets.chomp.downcase
		get_listings(city)
	end

	def get_listings(city)
		page = HTTParty.get("https://#{city}.craigslist.org/search/pet?s=0")
		parse_page = Nokogiri::HTML(page)
		pets_array = []
		parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
			post_name = a.text
			pets_array.push(post_name)
		end
		 CreateFile.new.push_to_file(pets_array)
	end
end

class CreateFile
	def push_to_file(pets_array)
		puts "What would you like to name this search?"
		name = gets.chomp
		date = DateTime.now
		CSV.new("pet_search_#{name}_#{date}.csv")
		CSV.open("pet_search_#{name}_#{date}.csv", "w") do |csv|
			csv << pets_array
		end
	end
end

run = GetListings.new
run
#Pry.start(binding)










