class_name Barkeeper
extends Area2D

var sm:StateMachine = null
var _orders:Orders = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("WaitressArrived",[TYPE_OBJECT])
	add_user_signal("onClick",[TYPE_OBJECT])
	sm=SM_Barkeeper.new()
	sm.set_target(self)
	sm.register_state(S_Idle.new())
	sm.register_state(S_Working.new())	
	sm.transition(S_Idle.getID())

func init(orders:Orders):
	_orders=orders	

func _on_TextureButton_pressed():
	emit_signal("onClick", self)	

func _on_Button_In_pressed():
	emit_signal("onClick", self)

func _on_Button_Out_pressed():
	emit_signal("onClick", self)


func _on_Barkeeper_area_entered(area):
	emit_signal("WaitressArrived", self)

func updateClock(total:float):
	sm.updateClock(total)

class SM_Barkeeper:
	extends StateMachine
	func updateClock(obj):
		if current_state.has_method("updateClock"): current_state.updateClock(obj)

class S_Idle:
	extends State
	
	static func getID():
		return("idle")



class S_Working:
	extends State
	
	static func getID():
		return("working")
