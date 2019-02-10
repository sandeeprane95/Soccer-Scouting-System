## Soccer Scouting System

Soccer is a game played by 250 million players over 200 countries and dependencies, making it the world’s most popular sport. In modern world, soccer is not just a game, it is a business. Today, soccer clubs are being owned and fueled by the billionaires. Managing a football club itself has become a big task. A main entity for any football club is its manager. They are the ones who have the prime responsibility of preparing the players for the matches, maintaining integrity, decision making, recruitment, etc. To assist a manager, there are several Scouts in the backroom staff, who are always on the hunt for talented players. A Scout is primarily responsible for providing the manager with a list of potential targets whenever the transfer window opens.  

The Soccer Scouting System is a rule-based system that can perform the job of an actual scout. A club may want to replace a player who might be retiring at the end of the season or may be seeking reinforcements to their current squads. They might be seeking a specific player position.  

The Soccer Scouting System provides a list of potential players given the transfer budget of the club, club agent’s reputation, required player position, etc.  

## Features

The user of the system will provide the following to the soccer scouting system:  
- User name (aka ‘The club agent name’) – You may enter any name of your choice, there is no restriction on this field.  
- Club which he/she represents – Again the user may choose any club of his/her own choice, no matter if it exists or not.  
- Scouting experience (aka ‘Scout reputation’) – The number of years that the club agent has been representing the club. This is a value between 0-30. Higher the value, higher are the chances of signing a player.  
- Player Position – The position for which the club is trying to sign a player. Can be either ‘goalkeeper’, ‘defender’, ‘midfielder’, ‘forward’.  
- Player Specific Position – The specific position for a player. This is a specialized case of the previous field. If player position is ‘goalkeeper’ then specific position option available is ‘goalkeeper’. For ‘defender’ one can choose either a ‘leftback’, ‘rightback’ or ‘centerback’. For ‘midfielder’ one can choose either a ‘leftmid’, ‘rightmid’, ‘centermid’, ‘attackingmid’ or ‘defensivemid’. For ‘forward’ one can choose either ‘leftwing’, ‘rightwing’ or ‘striker’.  
- Player strong foot – Specify if you want a player who is left footed or right footed or if it doesn’t matter to you. Possible options are ‘left’, ‘right’ or ‘any’.  
- Transfer Budget – Specify the transfer budget in million GBP. Range is from 0-100.  

## Rules and Description

The system has a total of 26 different rules. These are as follows:  
1. Rule 1 – Accepting the input, asserting template objects and performs a mandatory precheck for input validations.  
2. Rule 2 – Invalid inputs trigger this rule.  
- A default output is given.  
3. Rule 3 to 14 – Position type mismatch rule. These set of rules check for specific position mismatch with the generic player position.  
- An example of such a mismatch is when the user specifies the player position as ‘goalkeeper’ but specifies the specific position as ‘striker’.  
4. Rule 14 to 26 – These rules are responsible for providing the list of players for a specific position.  
- Each position can yield as many as 5 players. Since there are 12 different specific positions and 5 unique players for each position, a total of 60 player facts already exists in the memory.  
- Further the scouting experience is considered to predict the chances of signing the players in the list.  

## Steps to execute the .clp file

> Unpack the zip file and place the “SoccerScout.clp” file in the bin folder of jess.  
(sample path: Jess71p2/bin)  
> Run the batch(jess.bat) file. It will open the command prompt.  
> Now execute the command -> (batch “SoccerScout.clp”)  
> The application should start running.  

## Using the application:  

You’ll be asked a set of 7 questions. Each question has a prompt that assists you in answering the questions correctly. Some basic personal questions don’t have prompts which indicates that there is no specific right or wrong answer for those fields. Once you are done answering the 7 questions, the system would produce a list of players for your review.  
**Note that the system works on only valid inputs. It checks for validity and might fail to produce a list of players or it may throw some errors in case of invalid inputs.    

