require "pry"
require "Nokogiri"
require "HTTParty"
require "csv"
require "JSON"
require "awesome_print"

class GetListings

	def initialize
		ap "Which city do you wish to search?"
		city = gets.chomp.downcase
		ap"Type the 3 letter code of the catagory you wish to search?"
		ap"all: ccc"
		ap"artists: ats"
		ap"activity partners: act"
		ap"childcare: kid"
		ap"general: com"
		ap"groups: grp"
		ap"local news and views: vnn"
		ap"lost and found: laf"
		ap"musicians: muc"
		ap"pets: pet"
		ap"politics: pol"
		ap"rideshare: rid"
		ap"volunteers: vol"
		catagory = gets.chomp.downcase
		get_listings(city, catagory)
	end

	def get_listings(city, catagory)
		page = HTTParty.get("https://#{city}.craigslist.org/search/#{catagory}?s=0")
		parse_page = Nokogiri::HTML(page)
		listing_array = []
		parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
			post_name = a.text
			listing_array.push(post_name)
		end
		 CreateFile.new.push_to_file(listing_array)
	end
end

class CreateFile
	def push_to_file(listing_array)
		ap "What would you like to name this search?"
		name = gets.chomp
		date = DateTime.now
		file_name = "search_#{name}_#{date}.csv"
		CSV.new("#{file_name}")
		CSV.open("#{file_name}", "w") do |csv|
			csv << listing_array
		end
		DisplayResults.new.display(file_name)
	end
end

class DisplayResults
	def display(file_name)
		ap "Would you like to view the listings in the terminal? y/n"
		if gets.chomp.downcase == "y"
			file = CSV.open("#{file_name}", "r")
			file.each do |line|
				ap line
			end
		else
			ap "Goodbye"
			exit
		end
	end
end
GetListings.new










