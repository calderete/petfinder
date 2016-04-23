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
		file_name = "pet_search_#{name}_#{date}.csv"
		CSV.new("#{file_name}")
		CSV.open("#{file_name}", "w") do |csv|
			csv << pets_array
		end
		DisplayResults.new.display(file_name)
	end
end

class DisplayResults

	def display(file_name)
		puts "Would you like to view the listings in the terminal? y/n"
		if gets.chomp.downcase == "y"
			file = CSV.open("#{file_name}", "r")
			file.each do |line|
				puts line
			end
		else
			puts "Goodbye"
			exit
		end
	end
end


GetListings.new










