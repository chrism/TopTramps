require 'nokogiri'  
require 'open-uri'

class Person < ActiveRecord::Base
  
  
  acts_as_list

  def self.add_littlesis_list(littlesis_list_id)
    url = "http://api.littlesis.org/list/#{littlesis_list_id}/entities.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"
    doc = Nokogiri::XML(open(url))  
    people = doc.xpath("//Entities[1]//Entity")
    
    people.each do |person|
      add_littlesis_person(person)
    end
  end
  
  def self.add_person_by_littlesis_id(id)
    url = "http://api.littlesis.org/entity/#{id}.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"
    doc = Nokogiri::XML(open(url)) 
    person = doc.xpath("//Entity")
    
    add_littlesis_person(person)
  end
  
  def self.add_littlesis_person(person)

      littlesis_id = person.at("id").text.to_i   
      name = person.at("name").text

      puts "======================================="      
      puts "Processing littlsis id: #{littlesis_id}"    
      puts "name: #{name}"

      
      unless exists? :littlesis_id => littlesis_id
        
        # description & summary
        
        description = person.at("description").text
        summary = person.at("summary").text
        
        puts "Description exists" unless description.nil?
        puts "Summary exists" unless summary.nil?
        
        # getting the correct age
        
        start_date = person.at("start_date").text        
        puts "Processing start date: #{start_date}"
        
        if start_date == ""
          puts "Appears is empty string"
          age = nil
          else
          proper_date = Date.strptime(start_date, "%Y-")
          puts "Year appears to be #{proper_date}"
          age = 2011 - proper_date.year.to_i
          puts "Ages appears to be #{age}"
        end
        
        # getting relationships value as friends
        
        begin
          relations_doc = Nokogiri::XML(open("http://api.littlesis.org/entity/#{littlesis_id}/relationships/references.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"))
          friends = relations_doc.xpath("//TotalCount").text.to_i
          puts "Friends appear to be : #{friends}"
        rescue
          puts "Could not retrieve friends"
        end

        # getting image url
        begin
          images_doc =
      Nokogiri::XML(open("http://api.littlesis.org/entity/#{littlesis_id}/images.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639"))
          image_url = images_doc.xpath("//Images[1]//Image[is_featured>0]").at("source").text
          puts "image appears to be : #{image_url}"
        rescue
          puts "Could not retrive image url"
        end
        
        create!(
          :name => name,
          :littlesis_id => littlesis_id,
          :description => description,
          :summary => summary,
          :age => age,
          :image_url => image_url,
          :friends => friends
        )
      else
        
        puts "littlsis id: #{littlesis_id} already exists"
        
      end
      
    
  end
  
end
