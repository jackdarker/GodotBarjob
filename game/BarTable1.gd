class_name Table
extends Node2D

#var sm: StateMachine
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("onClick",[TYPE_OBJECT])
	add_user_signal("WaitressArrived",[TYPE_OBJECT])
#	sm = smf.create(
#	{"target": self,
#	"current_state": "empty",
#	"states": [{"id": "empty", "state": S_Empty},
#	{"id": "WaitToOrder", "state": S_WaitForOrder}],
#	"transitions": [{"state_id": "empty", "to_states": ["WaitToOrder"]},
#	{"state_id": "WaitToOrder", "to_states": ["empty"]}]})


func _on_TextureButton_pressed():
	emit_signal("onClick", self)	

func _on_BarTable_area_entered(area):
	emit_signal("WaitressArrived", self)	

class S_Empty:
	extends State
	"""
	no customer
	"""

class S_WaitForOrder:
	extends State


