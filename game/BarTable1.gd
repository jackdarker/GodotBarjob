class_name Table
extends Node2D
var smf: StateMachineFactory = StateMachineFactory.new()
var sm: StateMachine
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("onClick",[TYPE_OBJECT])
	add_user_signal("WaitressArrived",[TYPE_OBJECT])
	sm = smf.create(
	{"target": self,
	"current_state": "empty",
	"states": [{"id": "empty", "state": S_Empty},
	{"id": "WaitToOrder", "state": S_WaitForOrder}],
	"transitions": [{"state_id": "empty", "to_states": ["WaitToOrder"]},
	{"state_id": "WaitToOrder", "to_states": ["empty"]}]})

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sm._process(delta)
	
#func _unhandled_input(event):
#	get_node("Label").set_text("clock")

func _on_TextureButton_pressed():
	emit_signal("onClick", self)	

func _on_BarTable_area_entered(area):
	emit_signal("WaitressArrived", self)	

class S_Empty:
	extends State
	"""
	no customer
	"""

#	func _unhandled_input(event):
#		self.get_target().get_node("Label").set_text("clock")
		
class S_WaitForOrder:
	extends State
	"""
	no customer
	"""
	func _process(delta): 
		pass
	func _fixed_process(delta): 
		pass
	func _input(event): 
		pass
#	func _unhandled_input(event):
#		self.get_target().get_node("Label").set_text("click")

