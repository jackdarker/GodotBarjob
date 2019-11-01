#stores data that represents a choice for the player
class_name DialogChoice
extends Node

var _ID:int setget set_ID, get_ID
var _Text:String setget set_Text, get_Text
var _Tooltip:String setget set_Tooltip, get_Tooltip
var _Hidden:bool setget set_Hidden,get_Hidden
var _Disabled:bool setget set_Disabled,get_Disabled

func set_ID(ID:int):
	_ID=ID
	
func get_ID():
	return(_ID)
	
func set_Text(Text:String):
	_Text=Text
	
func get_Text():
	return(_Text)

func set_Tooltip(Text:String):
	_Tooltip=Text
	
func get_Tooltip():
	return(_Tooltip)
	
func set_Hidden(Hidden:bool):
	_Hidden=Hidden
	
func get_Hidden():
	return(_Hidden)	

func set_Disabled(Disabled:bool):
	_Disabled=Disabled
	
func get_Disabled():
	return(_Disabled)	

func init(ID:int,Text:String,Tooltip:String):
	set_ID(ID)
	set_Text(Text)
	set_Tooltip(Tooltip)
	set_Disabled(false)
	set_Hidden(false)

func _ready():
	pass
