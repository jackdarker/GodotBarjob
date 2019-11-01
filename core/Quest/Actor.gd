#used to display images and other things in the dialog
class_name Actor
extends Node

var _Images = {}

func get_Image(StageID:int):
	return(_Images[StageID])

func set_Images(Images):
	_Images = Images

var _textColor:=Color.beige
func get_TextColor():
	return(_textColor)

func set_textColor(color:Color):
	_textColor=color

func _ready():
	pass
