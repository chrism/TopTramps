task :cron => :environment do
  Person.add_littlesis_list(44)
  Person.add_littlesis_list(206)
end