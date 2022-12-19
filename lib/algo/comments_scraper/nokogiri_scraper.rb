require 'uri'
# gem install cgi
require 'cgi'
# gem install nokogiri
require 'nokogiri'
require 'open-uri'
store_name = "STARBUCKS 星巴克 (光復清大門市)"
# def scrape_comments(store_name)
  # Replace spaces with "+" and encode the store name for use in the URL
headers = { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'}
puts "Headers: #{headers}"

url = "https://www.google.com/maps/place/#{CGI.escape(store_name)}"

puts "Making request to: #{url}"

begin
    # Set the URL for the Google Maps page for the store
  html = open(url, headers).read
  puts "Response: #{html}"
  puts "HTML: #{html}"
rescue => e
  puts "Error: #{e.message}"
end
puts "HTML: #{html}"

# Open the page and parse it with Nokogiri
doc = Nokogiri::HTML(html)
# Find the elements containing the comments and store them in a list
comments = doc.xpath("//div[@class='section-review-content']")
puts 123
# Initialize an empty array to store the comment texts
comment_texts = []

# Iterate through the comments and add the text to the array
comments.each do |comment|
    comment_texts << comment.text
end

# Return the array of comment texts
comment_texts
# end


# comments = scrape_comments(store_name)
# puts comments