#derive from this class and implement the arked functions to create your dialog 
class_name DialogScene
extends Node

signal stage_changed
signal scene_finished

var _Actors = {}
var _ActualStage:DialogResponse setget set_ActualStage,get_ActualStage
var _NewStage:DialogResponse

func set_Actors(Actors):
	_Actors=Actors

func get_Actor(ID:int):
	return(_Actors[ID])

func get_ActualStage():
	return(_ActualStage)

func set_ActualStage(Stage:DialogResponse):
	_ActualStage = Stage
	emit_signal("stage_changed")

func scene_finished():
	emit_signal("scene_finished")
	
func _ready():
	pass

#override this and respond to user choice either by call set_ActualStage to switch to next stage
#or call scene_finished
func _HandleChoice(ActualStageID:int, ChoiceID:int):
	pass

func start():
	_NewStage = StartStage.new()
	_NewStage.setup()
	_ActualStage= _NewStage
	choiceSelected(0)

func choiceSelected(ID:int):
	if(!_ActualStage.get_Choices().has(ID)):
		_NewStage = MissingStage.new();
		_NewStage.createTextInvalidChoice(_ActualStage.get_ID(), ID)
		set_ActualStage(_NewStage)
		return
	
	_HandleChoice(_ActualStage.get_ID(),ID)
	
class StartStage:
	extends DialogResponse	
	func setup():
		set_ID(0)
		set_Text("no text here !")
		var _choice:DialogChoice = DialogChoice.new()
		_choice.set_ID(0)
		set_Choices({_choice.get_ID():_choice}) 

class MissingStage:
	extends DialogResponse
	var wrongChoice = "unknown choice {choice} at stage {stage}"
	
	func createTextInvalidChoice(StageID:int,ChoiceID:int):
		set_Text(wrongChoice.format({"choice": ChoiceID, "stage": StageID}))