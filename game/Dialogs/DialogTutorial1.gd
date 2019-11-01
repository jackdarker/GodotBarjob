class_name Tut1
extends DialogScene

enum {STAGE_START = 0, 
	STAGE_WELCOME = 10, 
	STAGE_END = 15,
	STAGE_SKIP_TUTORIAL = 20,
	STAGE_TUTORIAL1 = 30
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
					_Stage.init(STAGE_END,"So no tutorial", _choices)
				_:
					_Stage.init(STAGE_TUTORIAL1,"You have to ask the customer...", _choices)
		
		STAGE_END:
			scene_finished()
			return
	
	set_ActualStage(_Stage)
	
func addChoice(ID:int,Text:String, Tooltip:String):
	_choice = DialogChoice.new()
	_choice.init(ID,Text,Tooltip)
	_choices[_choice.get_ID()] = _choice
	