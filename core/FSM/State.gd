class_name State
extends Node
	# State ID
var _id setget set_id, get_id

# Target for the state (object, node, etc)
var _target setget set_target, get_target

# Reference to state machine
var _state_machine setget set_state_machine, get_state_machine

func set_id(id):
	_id=id

func get_id():
	return(_id)

func set_target(target):
	_target=target

func get_target():
	return(_target)
	
func set_state_machine(sm):
	_state_machine=sm

func get_state_machine():
	return(_state_machine)
# State machine callback called during transition when entering this state
func _on_enter_state(): pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): pass

func _process(delta): pass
func _fixed_process(delta): pass
func _input(event): pass
func onGoto(obj): pass
func onInteract(obj): pass