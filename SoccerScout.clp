(deftemplate scouter 
    (slot agentName)
    (slot clubName)
    (slot scoutYears)
	(slot transferBudget)	
)

(deftemplate playerSearch 
    (slot playerPosition) 
    (slot specificPosition) 
    (slot strongFoot) 
    (slot transferBudget)
)

(deftemplate execution 
    (slot isComplete)
)

(deftemplate inputTaken 
    (slot inp)
    (slot isValid)
)

(deftemplate playersRecommended
	(slot playerName)
	(slot playerPos)
	(slot currClub)
	(slot playerNationality)
	(slot estimatedValue)
)   

(defglobal 
    ?*agentName* = nil
    ?*clubName* = nil
	?*scoutYears* = 0
    ?*playerPosition* =  "any"
    ?*specificPosition* = "any"
    ?*strongFoot* = "any"
    ?*transferBudget* = 0
    ?*isValidInp* = 0
    ?*isExecuted* = 0 	
)

(defrule takeInput
    =>
    (printout t crlf crlf "--------------------------SOCCER SCOUT----------------------------" crlf)
	(printout t crlf "This application would suggest you the best players available on the transfer market as per your positional needs, budget and reputation" crlf)
    (printout t "**NOTE: Refer the documentation if you need any assistance while filling out the questionnaire." crlf crlf)
    (printout t "------------------------------------------------------------------" crlf crlf)        
    (printout t "Please enter your/club agent's name: " crlf)
    (bind ?*agentName* (read t))
    (printout t crlf "How many years of scouting experience do you have? Enter a value between 0-30" crlf)
    (bind ?*scoutYears* (read t))
    (printout t crlf "Enter the soccer club which you represent:" crlf)
    (bind ?*clubName* (read t))
    (printout t crlf "What is the position of the player that you looking for in the transfer market? Possible positions might be 'goalkeeper', 'defender', 'midfielder', 'forward':" crlf)
    (bind ?*playerPosition* (read t))
    (printout t crlf "Is there a specific position within this category that you are looking at? Specific positions might be 'goalkeeper', 'centerback', 'leftback', 'rightback', 'leftmid', 'rightmid', 'defensivemid', 'attackingmid', 'centermid', 'striker', 'leftwing', 'rightwing':" crlf)
    (bind ?*specificPosition* (read t))
	(printout t crlf "Would you prefer a player with a stronger right foot or stronger left foot? Valid options are 'any', 'left', 'right':" crlf)
    (bind ?*strongFoot* (read t))
	(printout t crlf "What is your transfer budget for signing a player who plays in this position (in million GBP)? Enter a value between 0-100." crlf)
    (bind ?*transferBudget* (read t))
	(bind ?*scoutYears* (/ ?*scoutYears* 6))
	(assert (scouter (agentName ?*agentName*) (clubName ?*clubName*) (scoutYears ?*scoutYears*) (transferBudget ?*transferBudget*)))
    (assert (playerSearch (playerPosition ?*playerPosition*) (specificPosition ?*specificPosition*) (strongFoot ?*strongFoot*) (transferBudget ?*transferBudget*)))
    (assert (execution (isComplete 0)))
	(preCheck)        
)

(deffunction preCheck()
	(bind ?*isValidInp* 0)
    (if (and (>= ?*scoutYears* 0) (<= ?*scoutYears* 30)) then
			(bind ?*isValidInp* 1)
		else
			(bind ?*isValidInp* 0)
			(printout t "Invalid yrs")
	)
	(if (= ?*isValidInp* 1) then
		(if (or (= (str-compare ?*playerPosition* "goalkeeper") 0) (= (str-compare ?*playerPosition* "defender") 0) (= (str-compare ?*playerPosition* "midfielder") 0) (= (str-compare ?*playerPosition* "forward") 0)) then
				(bind ?*isValidInp* 1)
			else 
				(bind ?*isValidInp* 0)
		)	
	)
	(if (= ?*isValidInp* 1) then
		(if (or (= (str-compare ?*specificPosition* "any") 0) (= (str-compare ?*specificPosition* "goalkeeper") 0) (= (str-compare ?*specificPosition* "centerback") 0) (= (str-compare ?*specificPosition* "leftback") 0) (= (str-compare ?*specificPosition* "rightback") 0) (= (str-compare ?*specificPosition* "leftmid") 0) (= (str-compare ?*specificPosition* "rightmid") 0) (= (str-compare ?*specificPosition* "defensivemid") 0) (= (str-compare ?*specificPosition* "attackingmid") 0) (= (str-compare ?*specificPosition* "centermid") 0) (= (str-compare ?*specificPosition* "striker") 0) (= (str-compare ?*specificPosition* "leftwing") 0) (= (str-compare ?*specificPosition* "rightwing") 0)) then
				(bind ?*isValidInp* 1)
			else 
				(bind ?*isValidInp* 0)
		)
	)
	(if (= ?*isValidInp* 1) then
		(if (or (= (str-compare ?*strongFoot* "any") 0) (= (str-compare ?*strongFoot* "left") 0) (= (str-compare ?*strongFoot* "right") 0)) then
				(bind ?*isValidInp* 1)
			else
				(bind ?*isValidInp* 0)
		)
	)
	(if (= ?*isValidInp* 1) then
		(if (and (>= ?*transferBudget* 0) (<= ?*transferBudget* 100)) then
				(bind ?*isValidInp* 1)
			else
				(bind ?*isValidInp* 0)
		)	
	)
		
    (assert (inputTaken (inp 1) (isValid ?*isValidInp*))) 
)

(defrule invalidInput
    (inputTaken (inp 1)(isValid 0)) (execution (isComplete 0))
    =>
    (printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "You have entered an invalid input. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule gkMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition goalkeeper){playerPosition != goalkeeper})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match. The specific position indicates goalkeeper but the general player position wasn't specified to be goalkeeper. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule gkMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition goalkeeper)(playerPosition goalkeeper))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of goalkeepers compiled for you:" crlf)
	(if (< ?*transferBudget* 6) then
	(printout t crlf "Sorry there are no goalkeepers available currently in the market for lesser than 6 million GBP." crlf)
	)
	(if (<= 6 ?*transferBudget*) then
	(printout t crlf "Name: Alex Smithies" crlf "Nationality: England" crlf "Current Club: Cardiff City" crlf "Position: Goalkeeper" crlf "Estimated Transfer Value: 6 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Jordan Pickford" crlf "Nationality: England" crlf "Current Club: Everton" crlf "Position: Goalkeeper" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 42 ?*transferBudget*) then
	(printout t crlf "Name: Jan Oblak" crlf "Nationality: Slovenia" crlf "Current Club: Atletico Madrid" crlf "Position: Goalkeeper" crlf "Estimated Transfer Value: 42 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 60 ?*transferBudget*) then
	(printout t crlf "Name: Hugo Lloris" crlf "Nationality: France" crlf "Current Club: Tottenham Hotspur" crlf "Position: Goalkeeper" crlf "Estimated Transfer Value: 60 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 78 ?*transferBudget*) then
	(printout t crlf "Name: David De Gea" crlf "Nationality: Spain" crlf "Current Club: Manchester United" crlf "Position: Goalkeeper" crlf "Estimated Transfer Value: 78 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule lbMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition leftback){playerPosition != defender})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates leftback but the general player position wasn't specified as defender. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule lbMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition leftback)(playerPosition defender))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of left-backs compiled for you:" crlf)
	(if (< ?*transferBudget* 9) then
	(printout t crlf "Sorry there are no left-backs available currently in the market for lesser than 9 million GBP." crlf)
	)
	(if (<= 9 ?*transferBudget*) then
	(printout t crlf "Name: Ben Chilwell" crlf "Nationality: England" crlf "Current Club: Leicester City" crlf "Position: Left Back" crlf "Estimated Transfer Value: 9 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 24 ?*transferBudget*) then
	(printout t crlf "Name: Andrew Robertson" crlf "Nationality: Scotland" crlf "Current Club: Liverpool" crlf "Position: Left Back" crlf "Estimated Transfer Value: 24 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 42 ?*transferBudget*) then
	(printout t crlf "Name: Alex Sandro" crlf "Nationality: Brazil" crlf "Current Club: Juventus" crlf "Position: Left Back" crlf "Estimated Transfer Value: 42 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 61 ?*transferBudget*) then
	(printout t crlf "Name: Jordi Alba" crlf "Nationality: Spain" crlf "Current Club: Barcelona" crlf "Position: Left Back" crlf "Estimated Transfer Value: 61 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 78 ?*transferBudget*) then
	(printout t crlf "Name: Marcelo Vieira" crlf "Nationality: Brazil" crlf "Current Club: Real Madrid" crlf "Position: Left Back" crlf "Estimated Transfer Value: 78 million" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule rbMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition rightback){playerPosition != defender})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates rightback but the general player position wasn't specified as defender. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule rbMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition rightback)(playerPosition defender))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of right-backs compiled for you:" crlf)
	(if (< ?*transferBudget* 8) then
	(printout t crlf "Sorry there are no right-backs available currently in the market for lesser than 8 million GBP." crlf)
	)
	(if (<= 8 ?*transferBudget*) then
	(printout t crlf "Name: Nathaniel Clyne" crlf "Nationality: England" crlf "Current Club: AFC Bournemouth" crlf "Position: Right Back" crlf "Estimated Transfer Value: 8 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Alessandro Florenzi" crlf "Nationality: Italy" crlf "Current Club: AS Roma" crlf "Position: Right Back" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 40 ?*transferBudget*) then
	(printout t crlf "Name: Thomas Meunier" crlf "Nationality: Belgium" crlf "Current Club: Paris Saint-Germain" crlf "Position: Right Back" crlf "Estimated Transfer Value: 40 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 55 ?*transferBudget*) then
	(printout t crlf "Name: Kyle Walker" crlf "Nationality: England" crlf "Current Club: Manchester City" crlf "Position: Right Back" crlf "Estimated Transfer Value: 55 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 65 ?*transferBudget*) then
	(printout t crlf "Name: Joshua Kimmich" crlf "Nationality: Germany" crlf "Current Club: Bayern Munich" crlf "Position: Right Back" crlf "Estimated Transfer Value: 65 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule cbMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition centerback){playerPosition != defender})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates centerback but the general player position wasn't specified as defender. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule cbMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition centerback)(playerPosition defender))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of center-backs compiled for you:" crlf)
	(if (< ?*transferBudget* 10) then
	(printout t crlf "Sorry there are no center-backs available currently in the market for lesser than 10 million GBP." crlf)
	)
	(if (<= 10 ?*transferBudget*) then
	(printout t crlf "Name: James Tomkins" crlf "Nationality: England" crlf "Current Club: Crystal Palace" crlf "Position: Center Back" crlf "Estimated Transfer Value: 10 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 24 ?*transferBudget*) then
	(printout t crlf "Name: Diego Godin" crlf "Nationality: Uruguay" crlf "Current Club: Atletico Madrid" crlf "Position: Center Back" crlf "Estimated Transfer Value: 24 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 46 ?*transferBudget*) then
	(printout t crlf "Name: Mats Hummels" crlf "Nationality: Germany" crlf "Current Club: Bayern Munich" crlf "Position: Center Back" crlf "Estimated Transfer Value: 46 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 75 ?*transferBudget*) then
	(printout t crlf "Name: Sergio Ramos" crlf "Nationality: Spain" crlf "Current Club: Real Madrid" crlf "Position: Center Back" crlf "Estimated Transfer Value: 75 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 80 ?*transferBudget*) then
	(printout t crlf "Name: Virgil Van Dijk" crlf "Nationality: Netherlands" crlf "Current Club: Liverpool" crlf "Position: Center Back" crlf "Estimated Transfer Value: 80 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule lmMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition leftmid){playerPosition != midfielder})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates leftmid but the general player position wasn't specified as midfielder. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule lmMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition leftmid)(playerPosition midfielder))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of left-midfielders compiled for you:" crlf)
	(if (< ?*transferBudget* 8) then
	(printout t crlf "Sorry there are no left midfielders available currently in the market for lesser than 8 million GBP." crlf)
	)
	(if (<= 8 ?*transferBudget*) then
	(printout t crlf "Name: Robert Snodgrass" crlf "Nationality: Scotland" crlf "Current Club: West Ham United" crlf "Position: Left Midfielder" crlf "Estimated Transfer Value: 8 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Yacine Brahimi" crlf "Nationality: Algeria" crlf "Current Club: FC Porto" crlf "Position: Left Midfielder" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 30 ?*transferBudget*) then
	(printout t crlf "Name: Ivan Perisic" crlf "Nationality: Croatia" crlf "Current Club: Inter Milan" crlf "Position: Left Midfielder" crlf "Estimated Transfer Value: 30 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 42 ?*transferBudget*) then
	(printout t crlf "Name: Marco Reus" crlf "Nationality: Germany" crlf "Current Club: Borussia Dortmund" crlf "Position: Left Midfielder" crlf "Estimated Transfer Value: 42 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 60 ?*transferBudget*) then
	(printout t crlf "Name: Koke" crlf "Nationality: Spain" crlf "Current Club: Atletico Madrid" crlf "Position: Left Midfielder" crlf "Estimated Transfer Value: 60 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule rmMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition rightmid){playerPosition != midfielder})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates rightmid but the general player position wasn't specified as midfielder. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule rmMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition rightmid)(playerPosition midfielder))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of right-midfielders compiled for you:" crlf)
	(if (< ?*transferBudget* 12) then
	(printout t crlf "Sorry there are no right midfielders available currently in the market for lesser than 12 million GBP." crlf)
	)
	(if (<= 12 ?*transferBudget*) then
	(printout t crlf "Name: Edin Visca" crlf "Nationality: Bosnia and Herzegovina" crlf "Current Club: Medipol Basaksehir" crlf "Position: Right Midfielder" crlf "Estimated Transfer Value: 12 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Samu Castillejo" crlf "Nationality: Spain" crlf "Current Club: Ac Milan" crlf "Position: Right Midfielder" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 27 ?*transferBudget*) then
	(printout t crlf "Name: Ricardo Quaresma" crlf "Nationality: Portugal" crlf "Current Club: Besiktas" crlf "Position: Right Midfielder" crlf "Estimated Transfer Value: 27 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 30 ?*transferBudget*) then
	(printout t crlf "Name: Juan Cuadrado" crlf "Nationality: Colombia" crlf "Current Club: Juventus" crlf "Position: Right Midfielder" crlf "Estimated Transfer Value: 30 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 34 ?*transferBudget*) then
	(printout t crlf "Name: Arjen Robben" crlf "Nationality: Netherlands" crlf "Current Club: Bayern Munich" crlf "Position: Right Midfielder" crlf "Estimated Transfer Value: 34 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule cmMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition centermid){playerPosition != midfielder})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates centermid but the general player position wasn't specified as midfielder. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule cmMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition centermid)(playerPosition midfielder))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of central-midfielders compiled for you:" crlf)
	(if (< ?*transferBudget* 8) then
	(printout t crlf "Sorry there are no attacking midfielders available currently in the market for lesser than 8 million GBP." crlf)
	)
	(if (<= 8 ?*transferBudget*) then
	(printout t crlf "Name: Markus Henriksen" crlf "Nationality: Norway" crlf "Current Club: Hull City" crlf "Position: Central Midfielder" crlf "Estimated Transfer Value: 8 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Scott McTominay" crlf "Nationality: Scotland" crlf "Current Club: Manchester United" crlf "Position: Central Midfielder" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 40 ?*transferBudget*) then
	(printout t crlf "Name: Radja Nainggolan" crlf "Nationality: Belgium" crlf "Current Club: AS Roma" crlf "Position: Central Midfielder" crlf "Estimated Transfer Value: 40 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 66 ?*transferBudget*) then
	(printout t crlf "Name: Toni Kroos" crlf "Nationality: Germany" crlf "Current Club: Real Madrid" crlf "Position: Central Midfielder" crlf "Estimated Transfer Value: 66 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 82 ?*transferBudget*) then
	(printout t crlf "Name: Luca Modric" crlf "Nationality: Croatia" crlf "Current Club: Real Madrid" crlf "Position: Central Midfielder" crlf "Estimated Transfer Value: 82 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule amMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition attackingmid){playerPosition != midfielder})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates attackingmid but the general player position wasn't specified as midfielder. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule amMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition attackingmid)(playerPosition midfielder))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of attacking-midfielders compiled for you:" crlf)
	(if (< ?*transferBudget* 12) then
	(printout t crlf "Sorry there are no attacking midfielders available currently in the market for lesser than 12 million GBP." crlf)
	)
	(if (<= 12 ?*transferBudget*) then
	(printout t crlf "Name: Harry Wilson" crlf "Nationality: Wales" crlf "Current Club: Derby County" crlf "Position: Central Attacking Midfielder" crlf "Estimated Transfer Value: 12 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Dimitri Payet" crlf "Nationality: France" crlf "Current Club: Marseille" crlf "Position: Central Attacking Midfielder" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 42 ?*transferBudget*) then
	(printout t crlf "Name: Mesut Ozil" crlf "Nationality: Germany" crlf "Current Club: Arsenal" crlf "Position: Central Attacking Midfielder" crlf "Estimated Transfer Value: 42 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 60 ?*transferBudget*) then
	(printout t crlf "Name: Christian Eriksen" crlf "Nationality: Denmark" crlf "Current Club: Tottenham Hotspur" crlf "Position: Central Attacking Midfielder" crlf "Estimated Transfer Value: 60 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 85 ?*transferBudget*) then
	(printout t crlf "Name: Kevin De Bruyne" crlf "Nationality: Belgium" crlf "Current Club: Manchester City" crlf "Position: Central Attacking Midfielder" crlf "Estimated Transfer Value: 85 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule dmMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition defensivemid){playerPosition != midfielder})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates defensivemid but the general player position wasn't specified as midfielder. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule dmMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition defensivemid)(playerPosition midfielder))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of defensive-midfielders compiled for you:" crlf)
	(if (< ?*transferBudget* 7) then
	(printout t crlf "Sorry there are no defensive midfielders available currently in the market for lesser than 7 million GBP." crlf)
	)
	(if (<= 7 ?*transferBudget*) then
	(printout t crlf "Name: Luka Milivojević" crlf "Nationality: Serbia" crlf "Current Club: Crystal Palace" crlf "Position: Central Defensive Midfielder" crlf "Estimated Transfer Value: 7 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 24 ?*transferBudget*) then
	(printout t crlf "Name: Fabinho" crlf "Nationality: Brazil" crlf "Current Club: Liverpool" crlf "Position: Central Defensive Midfielder" crlf "Estimated Transfer Value: 24 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 42 ?*transferBudget*) then
	(printout t crlf "Name: Casemiro" crlf "Nationality: Brazil" crlf "Current Club: Real Madrid" crlf "Position: Central Defensive Midfielder" crlf "Estimated Transfer Value: 42 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 64 ?*transferBudget*) then
	(printout t crlf "Name: Sergio Busquets" crlf "Nationality: Spain" crlf "Current Club: Barcelona" crlf "Position: Central Defensive Midfielder" crlf "Estimated Transfer Value: 64 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 70 ?*transferBudget*) then
	(printout t crlf "Name: N'Golo Kante" crlf "Nationality: France" crlf "Current Club: Chelsea" crlf "Position: Central Defensive Midfielder" crlf "Estimated Transfer Value: 70 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule lwMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition leftwing){playerPosition != forward})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates leftwing but the general player position wasn't specified as forward. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule lwMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition leftwing)(playerPosition forward))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of left-wingers compiled for you:" crlf)
	(if (< ?*transferBudget* 11) then
	(printout t crlf "Sorry there are no left wingers available currently in the market for lesser than 11 million GBP." crlf)
	)
	(if (<= 11 ?*transferBudget*) then
	(printout t crlf "Name: Junior Stanislas" crlf "Nationality: England" crlf "Current Club: AFC Bournemouth" crlf "Position: Left Winger" crlf "Estimated Transfer Value: 11 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 22 ?*transferBudget*) then
	(printout t crlf "Name: Lorenzo Insigne" crlf "Nationality: Italy" crlf "Current Club: Napoli" crlf "Position: Left Winger" crlf "Estimated Transfer Value: 22 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 45 ?*transferBudget*) then
	(printout t crlf "Name: Sadio Mane" crlf "Nationality: Senegal" crlf "Current Club: Liverpool" crlf "Position: Left Winger" crlf "Estimated Transfer Value: 45 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 78 ?*transferBudget*) then
	(printout t crlf "Name: Cristiano Ronaldo" crlf "Nationality: Portugal" crlf "Current Club: Juventus" crlf "Position: Left Winger" crlf "Estimated Transfer Value: 78 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 88 ?*transferBudget*) then
	(printout t crlf "Name: Neymar Jr." crlf "Nationality: Brazil" crlf "Current Club: Paris Saint-Germain" crlf "Position: left Winger" crlf "Estimated Transfer Value: 88 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule rwMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition rightwing){playerPosition != forward})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates rightwing but the general player position wasn't specified as forward. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule rwMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition rightwing)(playerPosition forward))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of right-wingers compiled for you:" crlf)
	(if (< ?*transferBudget* 12) then
	(printout t crlf "Sorry there are no right wingers available currently in the market for lesser than 12 million GBP." crlf)
	)
	(if (<= 12 ?*transferBudget*) then
	(printout t crlf "Name: Andros Townsend" crlf "Nationality: England" crlf "Current Club: Crystal Palace" crlf "Position: Right Winger" crlf "Estimated Transfer Value: 12 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 20 ?*transferBudget*) then
	(printout t crlf "Name: Jose Callejón" crlf "Nationality: Spain" crlf "Current Club: Napoli" crlf "Position: Right Winger" crlf "Estimated Transfer Value: 20 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 45 ?*transferBudget*) then
	(printout t crlf "Name: Riyad Mahrez" crlf "Nationality: France" crlf "Current Club: Manchester City" crlf "Position: Right Winger" crlf "Estimated Transfer Value: 45 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 74 ?*transferBudget*) then
	(printout t crlf "Name: Mohamed Salah" crlf "Nationality: Egypt" crlf "Current Club: Liverpool" crlf "Position: Right Winger" crlf "Estimated Transfer Value: 74 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 95 ?*transferBudget*) then
	(printout t crlf "Name: Lionel Messi" crlf "Nationality: Argentina" crlf "Current Club: Barcelona" crlf "Position: Right Winger" crlf "Estimated Transfer Value: 95 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule stMismatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition striker){playerPosition != forward})
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "The specified player position and the specific position do not match . The specific position indicates striker but the general player position wasn't specified as forward. Hence our scout couldn't find a player on the basis of the inputs received." crlf)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)

(defrule stMatch
	(inputTaken (inp 1)(isValid 1)) (execution (isComplete 0))(playerSearch (specificPosition striker)(playerPosition forward))
	=>
	(printout t crlf crlf "--------------------------SCOUT REPORT----------------------------" crlf "Hello " ?*agentName* "!" crlf crlf "Here is a list of strikers compiled for you:" crlf)
	(if (< ?*transferBudget* 9) then
	(printout t crlf "Sorry there are no strikers available currently in the market for lesser than 10 million GBP." crlf)
	)
	(if (<= 10 ?*transferBudget*) then
	(printout t crlf "Name: Danny Ings" crlf "Nationality: England" crlf "Current Club: Southampton" crlf "Position: Striker" crlf "Estimated Transfer Value: 10 million GBP" crlf)
	(if (<= ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 24 ?*transferBudget*) then
	(printout t crlf "Name: Mauro Icardi" crlf "Nationality: Italy" crlf "Current Club: Inter Milan" crlf "Position: Striker" crlf "Estimated Transfer Value: 24 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 42 ?*transferBudget*) then
	(printout t crlf "Name: Alexandre Lacazette" crlf "Nationality: France" crlf "Current Club: Arsenal" crlf "Position: Striker" crlf "Estimated Transfer Value: 42 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 75 ?*transferBudget*) then
	(printout t crlf "Name: Harry Kane" crlf "Nationality: England" crlf "Current Club: Tottenham Hotspur" crlf "Position: Striker" crlf "Estimated Transfer Value: 75 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(if (<= 90 ?*transferBudget*) then
	(printout t crlf "Name: Kylian Mbappe" crlf "Nationality: France" crlf "Current Club: Paris Saint-Germain" crlf "Position: Striker" crlf "Estimated Transfer Value: 90 million GBP" crlf)
	(if (<= ?*scoutYears* 2) then 
	(printout t "Chances of Signing: Low" crlf)
	)
	(if (and (>= ?*scoutYears* 2)(<= ?*scoutYears* 3.5)) then 
	(printout t "Chances of Signing: Medium" crlf)
	)
	(if (> ?*scoutYears* 3.5) then 
	(printout t "Chances of Signing: High" crlf)
	)
	)
	(printout t crlf "------------------------------------------------------------------" crlf crlf)
    (assert (execution (isComplete 1)))
)


(reset)
(facts)
(run)