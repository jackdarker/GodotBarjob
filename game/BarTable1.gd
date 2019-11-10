class_name Table
extends Node2D

export(int) var TableID = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("onClick",[TYPE_OBJECT])
	add_user_signal("WaitressArrived",[TYPE_OBJECT])


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


