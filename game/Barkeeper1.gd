class_name Barkeeper
extends Area2D

var sm:StateMachine = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("WaitressArrived",[TYPE_OBJECT])
	add_user_signal("onClick",[TYPE_OBJECT])
	sm=StateMachine.new()
	sm.register_state(S_Idle.new())
	sm.register_state(S_Working.new())
	sm.set_target(self)
	
	sm.transition("idle")

func _on_TextureButton_pressed():
	emit_signal("onClick", self)	

func _on_Button_In_pressed():
	emit_signal("onClick", self)

func _on_Button_Out_pressed():
	emit_signal("onClick", self)


func _on_Barkeeper_area_entered(area):
	emit_signal("WaitressArrived", self)



class S_Idle:
	extends State
	
	static func getID():
		return("idle")

class S_Working:
	extends State
	
	static func getID():
		return("working")
