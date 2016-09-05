# health_tracker

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
    # "How are you feeling (physically) on a scale of 1-10"
    # "How are you feeling (mentally) on a scale of 1-10"
    # "Any physical ailments today?"
      # list them for user to choose from
    # "How many steps did you walk/run today?"
# print out the day's health data
# let the user access the data
    # run down of the week/month/all-time --> 
      # averages
      # % of days w ailments ()
