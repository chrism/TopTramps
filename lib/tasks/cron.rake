task :cron => :environment do
  Person.update_from_littlesis("http://api.littlesis.org/list/44/entities.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639")
  Person.update_from_littlesis("http://api.littlesis.org/list/206/entities.xml?_key=fc15dcb7e0c03274168edf831a7e729b048af639")
end