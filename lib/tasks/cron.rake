task :cron => :environment do
  require 'open-uri'

  doc = Nokogiri::XML(open("http://api.littlesis.org/list/44/entities.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"))

  doc.xpath("//Entities[1]//Entity").each do |person|
  name = person.at("name").text
  littlesis_id = person.at("id").text.to_i
  description = person.at("description").text
  summary = person.at("summary").text
  start_date = person.at("start_date").text

  puts "name : #{name}"
  puts "littlesis_id : #{littlesis_id}"

  if start_date == ""
    puts "start_date is empty"
    age = nil
    else
    puts "start date is THERE!!!"
    proper_date = Date.strptime(start_date, "%Y-")
    age = 2011 - proper_date.year.to_i
  end


  # code for getting relationships value as friends
  begin
    relations_doc = Nokogiri::XML(open("http://api.littlesis.org/entity/#{littlesis_id}/relationships/references.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"))
    friends = relations_doc.xpath("//TotalCount").text.to_i
  rescue
    puts "broken link"
  end

  # code for getting image url
  begin
    images_doc =
Nokogiri::XML(open("http://api.littlesis.org/entity/#{littlesis_id}/images.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"))
    puts images_doc.xpath("//Images[1]//Image[is_featured>0]").at("source").text
  rescue
    puts "no image :("
  end
  
  puts "description : #{description}"
  puts "summary : #{summary}"
  puts "age : #{age}"
  puts "friends : #{friends}"

  end
end