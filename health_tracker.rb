### CHALLENGE DIRECTIONS ###
# program w persistent data to make life better
# find several ops to try something NOT shown in video
  # can users create data?
  # retrieve it?
  # manipulate it?
# dont use classes

### Simple Health Tracker ###
### database ###
# set up database w columns for tracking:
    # id
    # the date
    # general physical status on scale 1-10
    # general mental status on scale 1-10
    # physical activity (steps walked/ran)
    # comment on physical ailments
    # ailments (foreign key)
      # ailment + comments
        # 1. headache/migraine 
        # 2. indigestion/stomach ache 
        # 3. fatigue 
        # 4. body aches
        # 5. flu or flu-like symptoms
        # 6. cold or cold-like symptoms
        # 7. depression/anxiety
        # 8. other 
        # 9. none
    
### UI ### 
# let the user to enter the data
    # "what is the date today"
      # or is there a way to automatically get today's date?
    # "How are you feeling (physically) on a scale of 1-10"
    # "How are you feeling (mentally) on a scale of 1-10"
    # "Any physical ailments today?"
      # list them for user to choose from
      # or if/else structure ??? 
      # or??????
    # "How many steps did you walk/run today?"
# let the user access the data
    # run down of the week/month/year? --> 
      # averages
      # % of days w ailments ()
    # print out a day's health data (any day/day entered)

require 'sqlite3'

#######################
### create database ###
#######################
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

# will add ailments to ailment table in terminal
$ailments = db.execute("SELECT * FROM ailments")
p $ailments.class
health = db.execute("SELECT * FROM health")
p $ailments

# INSERT INTO health (phys_stat, ment_stat, steps, ailment_cmt, ailment) VALUES (7, 8, 103, "tired", 3);

### methods for recording health ###
def record_health(db, phys_stat, ment_stat, steps, ailment_cmt, ailment)
  db.execute("INSERT INTO health (phys_stat, ment_stat, steps, ailment_cmt, ailment) VALUES (?, ?, ?, ?, ?)", [phys_stat, ment_stat, steps, ailment_cmt, ailment])
end

def get_health(db)
  puts "Let's record today's health!"
  puts "On a scale of 1 to 10, how are you feeling physically"
  phys_stat = gets.chomp.to_i

  puts "On a scale of 1 to 10, how are you feeling mentally"
  ment_stat = gets.chomp.to_i

  puts "How many steps did you walk/run today?"
  steps = gets.chomp.to_i #check delete commas method

  puts "Do you currently have any ailments?"
  $ailments.each do |ailment|
    puts "  for #{ailment[1]} type: #{ailment[0]}"
  end
  ailment = gets.chomp.to_i

  puts "Any comments about your current ailment (#{$ailments[ailment]}) you wish to record?"
  ailment_cmt = gets.chomp

  record_health(db, phys_stat, ment_stat, steps, ailment_cmt, ailment)
end

######################
### user interface ###
######################

get_health(db)

# def get_users_health
#   puts "Hello!"
#   puts "On a scale of 1 to 10, how are you feeling physically?"
#   phys_stat = gets.chomp.to_i

#   puts "On a scale of 1 to 10, how are you feeling physically?"
#   ment_stat = gets.chomp.to_i

#   puts "How many steps did you walk/run today?"
#   steps = gets.chomp.to_i

#   puts "Do you have any ailments, currently?"
#   $ailments.each do |ailment|
#     puts "for #{ailment[1]} type: #{ailment[0]}"
#   end
#   ailment = gets.chomp.to_i

#   puts "Any comments you want to record?"
#   ailment_cmt = gets.chomp

#   # record_health(db, phys_stat, ment_stat, steps, ailment_cmt, ailment)
# end

# get_users_health

# driver code
# record_health(db, 8, 8, 10000, "okay", 9)



