require 'nokogiri'  
require 'open-uri'

class Person < ActiveRecord::Base

  def self.update_from_littlesis(list_url)   
    doc = Nokogiri::XML(open(list_url))  
    add_person(doc.xpath("//Entities[1]//Entity"))    
  end
  
  private
  
  
  def self.add_person(people)
    people.each do |person|
      littlesis_id = person.at("id").text.to_i
      
      unless exists? :littlesis_id => littlesis_id
        start_date = person.at("start_date").text
        
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
          image_url = images_doc.xpath("//Images[1]//Image[is_featured>0]").at("source").text
        rescue
          puts "no image :("
        end
        
        create!(
          :name => person.at("name").text,
          :littlesis_id => person.at("id").text.to_i,
          :description => person.at("description").text,
          :summary => person.at("summary").text,
          :age => age,
          :image_url => image_url,
          :friends => friends
        )
      end
    end
    
  end
  
end
