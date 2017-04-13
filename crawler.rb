require 'rest_client'
require 'nokogiri'
require 'pry'

url = "url"
$host = "host.com"
$pro_sol_fea = ["Products", "Solutions", "Features"]
$services = ["Services"]
$all_links = []
$debugger = false
$file = File.open("data.txt", "w")

def recursive_method(links)
  links.each do |link|
    href = link # link.attributes["href"].value 
    puts href
    
    if link.include?($host)
      begin
        link_parsed_data = Nokogiri::HTML(RestClient.get(href))
        write_to_file(href, link_parsed_data)
        sub_links = link_parsed_data.xpath("//a").collect{|sub_link| sub_link.attributes["href"].value}-$all_links
        puts "Sub Links: #{sub_links.size}"
        $all_links += sub_links
        recursive_method(sub_links)
      rescue Exception => e
        puts e
        puts "Invalid link: #{href}"
        binding.pry if $debugger
      end
    end
  end  
end

def write_to_file(url, data)
  if $pro_sol_fea.collect{|key| data.include?(key)}.include?(true)
    $file.write(url+"\n")
    $file.write("Products: \n")
    $file.write(data)
    $file.write("\n")
  end
  if $services.collect{|key| data.include?(key)}.include?(true)
    $file.write(url+"\n")
    $file.write("Services: \n")
    $file.write(data)
    $file.write("\n")
  end
end

raw_data = RestClient.get(url)
parsed_data = Nokogiri::HTML(raw_data)
write_to_file(url, parsed_data.text)
parent_links = all_links = parsed_data.xpath("//a").collect{|link| link.attributes["href"].value}

recursive_method(parent_links)

puts "Total links: #{$all_links.size}"
binding.pry