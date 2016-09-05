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
    # print out a day's health data

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

#
$ailments = db.execute("SELECT * FROM ailments")
# p $ailments.class
# p $ailments

$health = db.execute("SELECT health.id, health.dt, health.phys_stat, health.ment_stat, health.steps, health.ailment_cmt, ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC")
# p $health.class
# p $health

$weeks_health = db.execute("SELECT health.id, health.dt, health.phys_stat, health.ment_stat, health.steps, health.ailment_cmt, ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT 7")
# p $weeks_health

$months_health = db.execute("SELECT health.id, health.dt, health.phys_stat, health.ment_stat, health.steps, health.ailment_cmt, ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT 30")


###############
### METHODS ###
###############
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

  puts "Any comments about your current ailment you wish to record?"
  ailment_cmt = gets.chomp

  record_health(db, phys_stat, ment_stat, steps, ailment_cmt, ailment)
end


### methods for accessing health data ###
def day_printer(db)
  puts "Here are your recorded health stats from today (#{$health[-1][1]})="
  puts "  Steps Walked/Ran: #{$health[0][4]}"
  puts "  Physical Status: #{$health[0][2]}/10"
  puts "  Mental Status: #{$health[0][3]}/10"
  puts "  Ailment: #{$health[0][6]}"
  puts "  Comments: #{$health[0][5]}"
end

### steps averages ###
def steps_avg_week(db)
  steps_tot = 0
  $weeks_health.each do |day|
    steps_tot += day[4]
  end
  steps_avg = steps_tot/7
  puts "Your average steps walk/ran in the past 7 entered days is: #{steps_avg} steps"
end

def steps_avg_month(db)
  steps_tot = 0
  $months_health.each do |day|
    steps_tot += day[4]
  end
  steps_avg = steps_tot/30
  puts "Your average steps walk/ran in the past 30 entered days is: #{steps_avg} steps"
end

def steps_avg_all(db)
  steps_tot = 0
  $health.each do |day|
    steps_tot += day[4]
  end
  steps_avg = steps_tot/$health.length
  puts "Your average steps walk/ran in the past #{$health.length} entered days is: #{steps_avg} steps"
end

### physical status avgs ###
def phys_avg_week(db)
  phys_tot = 0
  $weeks_health.each do |day|
    phys_tot += day[2]
  end
  phys_avg = phys_tot/7
  puts "Your average physical status in the past 7 entered days is: #{phys_avg}/10"
end

def phys_avg_month(db)
  phys_tot = 0
  $months_health.each do |day|
    phys_tot += day[2]
  end
  phys_avg = phys_tot/30
  puts "Your average physical status in the past 30 entered days is: #{phys_avg}/10"
end

def phys_avg_all(db)
  phys_tot = 0
  $health.each do |day|
    phys_tot += day[2]
  end
  phys_avg = phys_tot/$health.length
  puts "Your average physical status in the past #{$health.length} entered days is: #{phys_avg}/10"
end

### mental status avgs ###
def ment_avg_week(db)
  ment_tot = 0
  $weeks_health.each do |day|
    ment_tot += day[3]
  end
  ment_avg = ment_tot/7
  puts "Your average mental status in the past 7 entered days is: #{ment_avg}/10"
end

def ment_avg_month(db)
  ment_tot = 0
  $months_health.each do |day|
    ment_tot += day[3]
  end
  ment_avg = ment_tot/30
  puts "Your average mental status in the past 30 entered days is: #{ment_avg}/10"
end

def ment_avg_all(db)
  ment_tot = 0
  $health.each do |day|
    ment_tot += day[3]
  end
  ment_avg = ment_tot/$health.length
  puts "Your average mental status in the past #{$health.length} entered days is: #{ment_avg}/10"
end

### ailment stats ###
def ail_avg_week(db)
  weeks_ailments = db.execute("select ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT 7")
  rundown = Hash.new(0)

  weeks_ailments.each do |ailment|
    rundown[ailment] += 1
  end

  puts "Your recorded ailments in the past 7 days are as follows:"
  rundown.each do |ailment, num|
    percent = num.to_f/7 * 100
    puts "  You recorded #{ailment} #{num} times," 
    puts "    or ~#{percent.to_i} percent of the 7 entered days"
  end
end

def ail_avg_month(db)
  months_ailments = db.execute("select ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC LIMIT 30")
  rundown = Hash.new(0)

  months_ailments.each do |ailment|
    rundown[ailment] += 1
  end

  puts "Your recorded ailments in the past 30 days are as follows:"
  rundown.each do |ailment, num|
    percent = num.to_f/30 * 100
    puts "  You recorded #{ailment} #{num} times," 
    puts "    or ~#{percent.to_i} percent of the 30 entered days"
  end
end

def ail_avg_all(db)
  all_ailments = db.execute("select ailments.ailment FROM ailments JOIN health on ailments.id = health.ailment ORDER BY HEALTH.ID DESC")
  rundown = Hash.new(0)

  all_ailments.each do |ailment|
    rundown[ailment] += 1
  end

  puts "Your recorded ailments in the past #{all_ailments.length} days are as follows:"
  rundown.each do |ailment, num|
    percent = num.to_f/all_ailments.length * 100
    puts "  You recorded #{ailment} #{num} times," 
    puts "    or ~#{percent.to_i} percent of the #{all_ailments.length} entered days"
  end
end

# def week_stats(db)
#   puts "Here is this past weeks averages:"
#   step_tot = 0
#   phys_tot = 0
#   ment_tot = 0
#   (-1..-7).each do |day|
#       step_tot += day[4]
#       phys_tot += day[2]
#       ment_tot += day[3] 
#   end
#   step_avg = step_tot.to_f/7
#   phys_avg = phys_tot.to_f/7
#   ment_avg = ment_tot.to_f/7
#   puts "  Steps: #{step_avg}"
#   puts "  Physical Status: #{phys_avg}"
#   puts "  Mental Status: #{ment_avg}"
# end

######################
### user interface ###
######################




###################
### driver code ###
###################
# record_health(db, 8, 8, 10000, "okay", 9)
# get_health(db)
# day_printer(db)
# steps_avg_week(db)
# steps_avg_month(db)
# steps_avg_all(db)
# phys_avg_week(db)
# phys_avg_month(db)
# phys_avg_all(db)
# ment_avg_all(db)
# ment_avg_month(db)
# ment_avg_week(db)
ail_avg_week(db)
ail_avg_month(db)
ail_avg_all(db)