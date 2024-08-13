import sqlite3
import re
from flask import Flask, request, jsonify
from flask_cors import CORS
from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer
from chatterbot.logic import BestMatch, MathematicalEvaluation
app = Flask(__name__) #flask class represents web application
CORS(app) #cross origin for flask to allow to request resources from a different origin

class NBAChatbot:
    def __init__(self):
        # Creating chatbot
        self.chatbot = ChatBot("NBA Chatbot",
            storage_adapter='chatterbot.storage.SQLStorageAdapter',
            database_url='sqlite:///nba.sqlite',
            logic_adapters=[
                'chatterbot.logic.BestMatch',
                'chatterbot.logic.MathematicalEvaluation'
            ]
        )

        # Creating a ListTrainer instance
        self.trainer = ListTrainer(self.chatbot)


    def get_common_players(self):
    # Setting up the connection
        try:
            connection = sqlite3.connect("nba.sqlite")
            cursor = connection.cursor()
            # common_players is the first table
            common_players = cursor.execute("SELECT * FROM common_player_info").fetchall()
            return common_players
        except sqlite3.Error as error:
            print(f"An error occurred: {error}")
            return []


    def get_players(self):
        try:
            connection = sqlite3.connect("nba.sqlite")
            cursor = connection.cursor()
            
            # common_players is the first table
            active_players = cursor.execute("SELECT * FROM player").fetchall()
            return active_players
        except sqlite3.Error as error:
            #gives a error instead
            print(f"An error occurred: {error}")
            return []

    def get_team_data(self):
            # Set up the connection
        try:
            connection = sqlite3.connect("nba.sqlite")
            cursor = connection.cursor()
            # common_players is the first table
            common_players = cursor.execute("SELECT * FROM team").fetchall()
            return common_players
        except sqlite3.Error as error:
            print(f"An error occurred: {error}")
            return []
    

    def common_players_training_data(self,players):
       #goes through the SQL database and grabs the relevant information
        if players:
            training_data = []
            for player in players:
                if player[16] == 'Active':
                    fullname = player[3].lower()
                    country = player[9].lower()
                    height = player[11] if player[11] else "Unknown"
                    season = player[13] if player[13] else "Unknown"
                    jersey_number = player[14] if player[14] else "Unknown"
                    position = player[15].lower()
                    current_player = "No" if player[17] == 'N' else ("Yes" if player[17] == 'Y' else "Unknown")
                    full_team_name = f"{player[22].lower()} {player[19].lower()}"
                    from_year = player[24]
                    to_year = player[25]
                    played_nba = "No" if player[28] == 'N' else ("Yes" if player[28] == 'Y' else "Unknown")
                    draft_year = player[29] if player[29] else "Unknown"
                    print(f"Training Data for {fullname}: {full_team_name}")


                #creates inputlike responsees for the chatterbot to train
                    training_data.extend([
                        f"Did {fullname} play in the NBA?", f"Yes",
                        f"Where is {fullname} from?", f"Country: {country}",
                        f"Where is {fullname} originally from?", f"Country: {country}",
                        f"Where was {fullname} born?", f"Country: {country}",
                        f"What country is {fullname} from?", f"Country: {country}",
                        f"What is {fullname}'s height?", f"Height: {height}",
                        f"How tall is {fullname}?", f"Height: {height}",
                        f"What is {fullname}'s jersey number?", f"Jersey Number: {jersey_number}",
                        f"What jersey number did {fullname} wear?", f"Jersey Number: {jersey_number}",
                        f"What position did {fullname} play?", f"Position: {position}",
                        f"Is {fullname} a current player?", f"Current Player: {current_player}",
                        f"Does {fullname} still play?", f"Current Player: {current_player}",
                        f"Which team did {fullname} play for?", f"Team Name:{full_team_name}",
                        f"What team did {fullname} play for?", f"Team Name: {full_team_name}",
                        f"From which year did {fullname} start playing?", f"From Year: {from_year}",
                        f"Until which year did {fullname} play?", f"To Year: {to_year}",
                        f"When did {fullname} start playing?", f"From Year: {from_year}",
                        f"When did {fullname} play?", f"From Year: {from_year} to Year {to_year}",
                        f"How many seasons did {fullname} play?", f"Seasons played: {season}",
                        f"How many years did {fullname} play?", f"Years played: {season}",
                        f"Did {fullname} play in the NBA?", f"Played NBA: {played_nba}",
                        f"What year was {fullname} drafted?", f"Draft Year: {draft_year}",
                        f"When was {fullname} drafted?", f"Draft Year: {draft_year}",
                    ])
        else:
            print("No Player Found")
            return []
        return training_data



    def players_training_data(self, players):
        if players:
            playerlist = []
            #grabbing and creating input for the chatterbot
            for player in players:
                full_name = player[1].lower()
                if player[4] == 0:
                    is_active = "No"
                elif player[4] == 1:
                    is_active = "Yes"
                else:
                    is_active = "Unknown"
                playerlist.extend([
                    f"Does {full_name} play in the NBA?", is_active,
                    f"Did {full_name} play in the NBA?", "Yes",
                    f"Is {full_name} a current player?", is_active,
                    f"Is {full_name} in the Nba?", is_active,

                    
                ])
        else:
            print("No data found")
            return []
        return playerlist

    def team_training_data(self,teams):

        #getting the training data for the teams
        if teams:
            team_list = []
            for team in teams:
                full_name = team[1].lower()
                nick_name = team[3].lower()
                team_city = team[4].lower()
                year_founded =  team[6]
                age =  2024-year_founded
                team_list.extend([
                    f"What city do the {nick_name} play for?", f"They play for {team_city}.",
                    f"What city does the {nick_name} play for?", f"They play for {team_city}.",
                    f"When was the {nick_name} founded?", f"It was founded in {year_founded}.",
                    f"What is the name of the {nick_name}?", f"Their full name is {full_name}.",
                    f"What team is the {nick_name}?", f"The team name is {full_name}.",
                    f"How old are the {nick_name}?", f"They are {age} years old.",
                    f"Does {team_city} have a team", f"Yes they  are called the {full_name} years old.",



                ])

        else:
            print("No team found")
            return []
        return team_list


    def normalize_data(self,player_data,table):
        normalized_data = []
        #gathering all the players and teams
        for player in player_data:
            if table == 'common':
                normalized_data.append({
                    'id':player[0],
                    'full_name':player[3].lower() if player[3] else 'UNKNOWN',
                    'first_name':player[1].lower() if player[1] else 'UNKNOWN',
                    
                })
            elif table == 'active':
                normalized_data.append({
                    'id': player[0],
                    'full_name':player[1].lower() if player[1] else 'UNKNOWN', 
                    'first_name':player[2].lower()if player[2] else 'UNKNOWN',
                    'last_name':player[3].lower() if player[3] else 'UNKNOWN',
                    
                })
            elif table == 'team':
                normalized_data.append({
                    'id':player[0],
                    'full_name':player[1].lower() if player[1] else 'UNKNOWN',
                    'nick_name':player[3].lower() if player[3] else 'UNKNOWN',
                    'team_city':player[4].lower() if player[4] else 'UNKNOWN',
                    'year_founded':player[6],
                    })

        return normalized_data

    def combine_data(self,common_players,active_players,team_data):
       
        #combining all the players and teams into 1 giant list and removing duplicates
        combined_data = common_players + active_players + team_data
        unique_players_list = []
        unique_players_ids = set()

        for player in combined_data:
            if player['id'] not in unique_players_ids:
                unique_players_list.append(player)
                unique_players_ids.add(player['id'])



        return unique_players_list


    def trainchatbot(self,training_data):
        #training the chatbot
        if training_data:
            print("Training chatbot...")
            self.trainer.train(training_data)
            print("Training complete!")
        else:
            print("No player found")

    def more_information_needed_players(self,user_question,all_players):

        #creating lists to store the names/teams the user is looking for
        firstname = []
        lastname = []
        fullname =[]
        nickname = []
        teamcity = []    
        placeholder = 'UNKNOWN'
        for player in all_players:
            full_name = player.get('full_name',placeholder)
            first_name = player.get('first_name',placeholder)
            last_name = player.get('last_name',placeholder)
            nick_name = player.get('nick_name',placeholder)
            team_city = player.get('team_city',placeholder)

            
            #using regex to look for the names in the user input to append to the right list
            if re.search(r'\b'+ re.escape(full_name) + r'\b', user_question,re.IGNORECASE):
                fullname.append(full_name)
            
            if first_name!=placeholder and re.search(r'\b'+ re.escape(first_name) + r'\b', user_question,re.IGNORECASE):
               firstname.append(first_name)
            
            if  last_name!=placeholder and re.search(r'\b' + re.escape(last_name) + r'\b', user_question,re.IGNORECASE):
                lastname.append(last_name)
            
            if  nick_name!=placeholder and re.search(r'\b'+ re.escape(nick_name)+r'\b',user_question,re.IGNORECASE):
                nickname.append(nick_name)
            
            if  team_city!=placeholder and re.search(r'\b'+ re.escape(team_city)+r'\b',user_question,re.IGNORECASE):
                 teamcity.append(team_city)
        
        #if and elif cases to check if the user's question is not specific enough
        if len(fullname) == 1:
            return None
        elif len(lastname)>1 or len(nickname)>1 or len(teamcity)>1 or len(firstname)>1:
           
            return "There are multiple players with that name. Can you please provide the first and last name?"
            
        elif len(firstname)==1 or len(lastname)==1:
            return None
        elif len(nickname)==1:
            return None
        elif len(teamcity)==1:
            return None

        else:
            return "I cannot find the player in my database. Can you try again?"


#calling and storing all the functions
Nbachatbot = NBAChatbot()
common_players = Nbachatbot.get_common_players()
active_players= Nbachatbot.get_players()
teams= Nbachatbot.get_team_data()
common_training_data = Nbachatbot.common_players_training_data(common_players)
player_training_data =Nbachatbot.players_training_data(active_players)
team_training_data = Nbachatbot.team_training_data(teams)
Nbachatbot.trainchatbot(common_training_data)
Nbachatbot.trainchatbot(player_training_data)
Nbachatbot.trainchatbot(team_training_data)


#map the specific URL to function
@app.route('/chat', methods=['POST']) 
def chat():
    user_input =  request.json.get('message') 


#converts python dict to json 400 is bad request
    if not user_input:
        return jsonify({"error": "Invalid Input"}), 400 
    
    #requires user input must be greater than 2
    if len(user_input.split())<=2:
        return jsonify({"response": "Could you please provide more information or a full name?"})
    
    #creating a list of dictionaries to store the all the players and teams
    all_players = Nbachatbot.combine_data(
        Nbachatbot.normalize_data(common_players,'common'),
        Nbachatbot.normalize_data(active_players,'active'),
        Nbachatbot.normalize_data(teams,'team'),                 
        )
    
    more_info= Nbachatbot.more_information_needed_players(user_input,all_players)
   
    #if the user input is not enough, it will prompt the user to ask again
    if more_info:
        return jsonify({"response": more_info})
    else:
       #returning the response
       response = Nbachatbot.chatbot.get_response(user_input)
       print(f"Chatbot response: {response}")

       return jsonify({"response":str(response)})


if __name__ == "__main__":
    app.run(debug=True)

