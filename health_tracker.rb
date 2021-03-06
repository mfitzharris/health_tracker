require 'sqlite3'

#######################################
######### ** CREATE DATABASE ** #######
#######################################

db = SQLite3::Database.new("health.db")
# db.results_as_hash = true # do i want this??? play w later

ailment_table_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS ailments (
    id INTEGER PRIMARY KEY,
    ailment VARCHAR (255)
  )
SQL

health_table_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS health (
  id INTEGER PRIMARY KEY,
  dt datetime default current_timestamp,
  phys_stat INT,
  ment_stat INT,
  steps INT,
  ailment_cmt VARCHAR (255),
  ailment INT,
  FOREIGN KEY (ailment) REFERENCES ailments (id)
  )
SQL

db.execute(ailment_table_cmd)
db.execute(health_table_cmd)
# ailments added to ailment table in terminal


### create variables ###
def define_vars(db)
$ailments = db.execute("SELECT * FROM ailments")

$health = db.execute("SELECT health.id, health.dt, health.phys_stat, health.ment_stat, health.steps, health.ailment_cmt, ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC")

$weeks_health = db.execute("SELECT health.id, health.dt, health.phys_stat, health.ment_stat, health.steps, health.ailment_cmt, ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT 7")

$months_health = db.execute("SELECT health.id, health.dt, health.phys_stat, health.ment_stat, health.steps, health.ailment_cmt, ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT 30")
end

define_vars(db)





########################################
##########  ** METHODS **    ###########
########################################

#########################################
### methods for recording health data ###
#########################################

def record_health(db, phys_stat, ment_stat, steps, ailment_cmt, ailment)
  db.execute("INSERT INTO health (phys_stat, ment_stat, steps, ailment_cmt, ailment) VALUES (?, ?, ?, ?, ?)", [phys_stat, ment_stat, steps, ailment_cmt, ailment])
  define_vars(db)
end

def get_health(db)
  puts "Let's record today's health!"
  puts ">> On a scale of 1 to 10, how are you feeling physically"
  phys_stat = gets.chomp.to_i

  puts ">> On a scale of 1 to 10, how are you feeling mentally"
  ment_stat = gets.chomp.to_i

  puts ">> How many steps did you walk/run today?"
  steps = gets.chomp.to_i #check delete commas method

  puts ">> Do you currently have any ailments?"
  $ailments.each do |ailment|
    puts "  for #{ailment[1]} type: #{ailment[0]}"
  end
  ailment = gets.chomp.to_i

  puts ">> Any comments about your current status you wish to record?"
  ailment_cmt = gets.chomp

  record_health(db, phys_stat, ment_stat, steps, ailment_cmt, ailment)

end



#########################################
### methods for accessing health data ###
#########################################

def day_printer(db)
  puts "Here are your recorded health stats from today (#{$health[0][1]})="
  puts "  Steps Walked/Ran: #{$health[0][4]}"
  puts "  Physical Status: #{$health[0][2]}/10"
  puts "  Mental Status: #{$health[0][3]}/10"
  puts "  Ailment: #{$health[0][6]}"
  puts "  Comments: #{$health[0][5]}"
end

### steps averages ###
def steps_average(db, array)
  steps_tot = 0
  array.each do |day|
    steps_tot += day[4]
  end
  steps_avg = steps_tot/array.length
  puts "Your average steps walk/ran in the past #{array.length} entered days is: #{steps_avg} steps"
end


### physical status averages ###
def phys_average(db, array)
  phys_tot = 0
  array.each do |day|
    phys_tot += day[2]
  end
  phys_avg = phys_tot/array.length
  puts "Your average physical status in the past #{array.length} entered days is: #{phys_avg}/10"
end

### mental status averages ###
def ment_average(db, array)
  ment_tot = 0
  array.each do |day|
    ment_tot += day[3]
  end
  ment_avg = ment_tot/array.length
  puts "Your average mental status in the past #{array.length} entered days is: #{ment_avg}/10"
end

### ailment stats ###
def ail_average(db, array)
  just_ailments = db.execute("select ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT #{array.length}")
  rundown = Hash.new(0)

  just_ailments.each do |ailment|
    rundown[ailment] += 1
  end

  puts "Your recorded ailments in the past #{array.length} days are as follows:"
  rundown.each do |ailment, num|
    percent = num.to_f/array.length * 100
    puts "  You recorded #{ailment} #{num} times," 
    puts "    or ~#{percent.to_i} percent of the #{array.length} entered days"
  end
end


###############################################
#########  ** USER INTERFACE ** ###############
###############################################

puts "Hello!"
puts ">> To record today's health >> type: 1"
puts ">> To print out today's recorded health >> type: 2"
puts ">> To calculate data about previously recorded health >> type: 3"
puts ">> To exit >> type: 0"

input = gets.chomp.to_i
puts ""

until input == 0
  if input ==1
    get_health(db)
  elsif input == 2
    day_printer(db)
  elsif input == 3
    puts "What would you like to calculate?"
    puts "  >> for average steps walk/ran >> type: 1"
    puts "  >> for average physical health status >> type: 2"
    puts "  >> for average mental health status >> type: 3"
    puts "  >> for ailment related data >> type: 4"
    calc_input = gets.chomp.to_i

    if calc_input == 1
      puts ">> for weekly >> type: 1"
      puts ">> for monthly >> type: 2"
      puts ">> for all-time >> type: 3"
      step_input = gets.chomp.to_i

      if step_input == 1
        steps_average(db, $weeks_health)
      elsif step_input == 2
        steps_average(db, $months_health)
      elsif step_input == 3
        steps_average(db, $health)
      else
        puts "I'm sorry that is not valid input..."
      end

    elsif calc_input == 2
      puts ">> for weekly >> type: 1"
      puts ">> for monthly >> type: 2"
      puts ">> for all-time >> type: 3"
      phys_input = gets.chomp.to_i

      if phys_input == 1
        phys_average(db, $weeks_health)
      elsif phys_input == 2
        phys_average(db, $months_health)
      elsif phys_input == 3
        phys_average(db, $health)
      else
        puts "I'm sorry that is not valid input..."
      end

    elsif calc_input == 3
      puts ">> for weekly >> type: 1"
      puts ">> for monthly >> type: 2"
      puts ">> for all-time >> type: 3"
      ment_input = gets.chomp.to_i

      if ment_input == 1
        ment_average(db, $weeks_health)
      elsif ment_input == 2
        ment_average(db, $months_health)
      elsif ment_input == 3
        ment_average(db, $health)
      else
        puts "I'm sorry that is not valid input..."
      end

    elsif calc_input == 4
      puts ">> for weekly >> type: 1"
      puts ">> for monthly >> type: 2"
      puts ">> for all-time >> type: 3"
      ail_input = gets.chomp.to_i

      if ail_input == 1
        ail_average(db, $weeks_health)
      elsif ail_input == 2
        ail_average(db, $months_health)
      elsif ail_input == 3
        ail_average(db, $health)
      else
        puts "I'm sorry that is not valid input..."
      end

    else
      puts "I'm sorry that is not valid input..."

    end

  else
    puts "I'm sorry that is not valid input..."
  end
  puts ""
  puts ">> To record today's health type: 1"
  puts ">> To print out today's recorded health type: 2"
  puts ">> To calculate data about previously recorded health type: 3"
  puts ">> To exit type: 0"
  input = gets.chomp.to_i
end

puts "Thank you for recording your health! :)"
puts "Remember to record tomorrow's health too! Have a great day!"
