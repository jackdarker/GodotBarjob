class_name Table
extends Node2D

export(int) var TableID = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("onClick",[TYPE_OBJECT])
	add_user_signal("WaitressArrived",[TYPE_OBJECT])


func _on_TextureButton_pressed():
	emit_signal("onClick", self)	
	if(_alreadyThere):	#workaround if waitress already ar target
		emit_signal("WaitressArrived", self)

var _alreadyThere:bool = false
func _on_BarTable_area_entered(area):
	_alreadyThere = true
	emit_signal("WaitressArrived", self)	

func _on_BarTable1_area_exited(area):
	_alreadyThere = false

class S_Empty:
	extends State
	"""
	no customer
	"""

class S_WaitForOrder:
	extends State

