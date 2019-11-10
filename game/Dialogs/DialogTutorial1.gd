class_name Tut1
extends DialogScene

enum {STAGE_START = 0, 
	STAGE_WELCOME = 10, 
	STAGE_END = 15,
	STAGE_SKIP_TUTORIAL = 20,
	STAGE_TUTORIAL1 = 30,
	STAGE_TUTORIAL2 = 40,
	STAGE_TUTORIAL3 = 50
	}

func _ready():
	pass
	
var _choices
var _choice:DialogChoice

func _HandleChoice(ActualStageID:int, ChoiceID:int):
	var _Stage:= DialogResponse.new()
	_choices = {}
	
	match ActualStageID:
		STAGE_START:
			addChoice(0,"Skip","")
			addChoice(1,"Explain","")
			_Stage.init(STAGE_WELCOME,"[b]Welcome to the Bar.[/b] \n Would you like to get an introduction or just skip to the game?", _choices)
		STAGE_WELCOME:
			addChoice(0,"Next","")
			match ChoiceID:
				0:
					_Stage.init(STAGE_END,"So no tutorial for you.", _choices)
				_:
					_Stage.init(STAGE_TUTORIAL1,"Walk up to the guests at the table, greet them and ask what they want to drink. Then come back to the bar and give me those orders.", _choices)
		STAGE_TUTORIAL1:
			addChoice(0,"Next","")
			_Stage.init(STAGE_TUTORIAL2,"I will prepare those drinks and put them here for you for pick up.\n This will take a while but you should move on serving the preped drinks or taking more orders.", _choices)
		STAGE_TUTORIAL2:
			addChoice(0,"Next","")
			_Stage.init(STAGE_TUTORIAL3,"Serve the drinks to the customers. Make sure to remember what they ordered. \n Failing to do so will surely reduce your tip.", _choices)
		STAGE_TUTORIAL3:
			addChoice(0,"Finish","")
			_Stage.init(STAGE_END,"And remember: the customer is always right.", _choices)
		STAGE_END:
			scene_finished()
			return
		
		_:
			_Stage.init(STAGE_WELCOME,("unhandled stage {str}").format({"str":ActualStageID}),{})
	
	set_ActualStage(_Stage)
	
func addChoice(ID:int,Text:String, Tooltip:String):
	_choice = DialogChoice.new()
	_choice.init(ID,Text,Tooltip)
	_choices[_choice.get_ID()] = _choice
	