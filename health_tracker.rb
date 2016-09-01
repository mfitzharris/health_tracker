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
        # headache 
        # indigestion/stomach ache 
        # fatigue 
        # body aches
        # flu or flu-like symptoms
        # cold or cold-like symptoms
        # depression/anxiety
        # other 
        # none
    
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

db = SQLite3::Database.new("health.db")
db.results_as_hash = true # do i want this??? play w later

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






