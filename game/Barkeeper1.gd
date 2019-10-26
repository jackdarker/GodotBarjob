class_name Barkeeper
extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("WaitressArrived",[TYPE_OBJECT])
	add_user_signal("onClick",[TYPE_OBJECT])

func _on_TextureButton_pressed():
	emit_signal("onClick", self)	

func _on_Button_In_pressed():
	emit_signal("onClick", self)

func _on_Button_Out_pressed():
	emit_signal("onClick", self)


func _on_Barkeeper_area_entered(area):
	emit_signal("WaitressArrived", self)
