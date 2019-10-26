class_name Menu_CustomerOrder
extends Node

var _placeOrder:bool setget set_placeOrder,get_PlaceOrder
func set_placeOrder(placeOrder:bool):
	_placeOrder=placeOrder
	
func get_PlaceOrder():
	return _placeOrder
	
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("Done",[TYPE_OBJECT])

func _on_Button_OK_pressed():
	self.visible=false
	emit_signal("Done", self)	


func _on_Menu_Control_about_to_show():
	if(_placeOrder==true):
		get_node("Panel/Label").set_text("What does the customer want?")
	else:
		get_node("Panel/Label").set_text("The customer wants...")
		
