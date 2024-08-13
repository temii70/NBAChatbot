This is a chatbot that uses a sql database filled with users and teams to train the chatbot. You can ask it questions such as "Does Lebron James play in the Nba? or What team did James Harden play for?" and it will respond back to the user with the relevant information. The chatbot is powered by a Python backend, and the frontend can be displayed via SwiftUI.

Usage Questions you can ask the Chatbot:
"Which team did {player's full name} play for?"
"Where is {player's full name} from?"
"What city do the {team} play for?"


Requirements:
- Python 3.8 or lower: Make sure you have Python 3.8 installed (the chatbot may not work with higher versions).

- Virtual Environment: It's recommended to create a virtual environment to manage dependencies.

- Dependencies: All required packages are listed in requirements.txt.

- Dataset: The dataset is included in the repository, but if needed, you can download it from https://www.kaggle.com/datasets/wyattowalsh/basketball.

- Xcode with SwiftUI: You'll need Xcode installed to run the SwiftUI frontend.



Installation:

1) git clone https://github.com/temii70/nba-chatbot.git

2) go into the directory containing the folder

3) (Optional) If you're using Anaconda, you can create and activate a virtual environment:
    conda create -n nba-chatbot python=3.8
    conda activate nba-chatbot

4) pip install -r requirements.txt

5) Run the application:
    Python Chatbot.py

6) Navigate to the SwiftUI project directory and hit the build button

7) Enjoy!

