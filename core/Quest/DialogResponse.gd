#contains the message to display in the dialog view 
class_name DialogResponse
extends Node

var _ID:int setget set_ID, get_ID
var _Text:String setget set_Text, get_Text
var _Choices = {} setget set_Choices, get_Choices

func set_ID(ID:int):
	_ID=ID
	
func get_ID():
	return(_ID)
	
func set_Text(Text:String):
	_Text=Text
	
func get_Text():
	return(_Text) #todo flag if bbCode or not

func set_Choices(Choices):
	_Choices=Choices	#todo check array
	
func get_Choices():
	return(_Choices)

func init(ID:int,Text:String,Choices):
	set_ID(ID)
	set_Text(Text)
	set_Choices(Choices)

func _ready():
	pass
