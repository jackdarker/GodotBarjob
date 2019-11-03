class_name State
extends Node

signal go_to

const AUTO_METHOD_PREFIX := 'go_to ' # Prefix for implicit state change
const AUTO_TARGET_METHOD_PREFIX := '.' # Prefix for implicit target method calls

enum StateType {NORMAL, PUSH}

var state_name : String = ''
var state_type : int

var _timer : float = 0.0
var _timers : Dictionary = {}


# Target for the state (object, node, etc)
var _target: Node setget set_target, get_target

# Reference to state machine
var fsm setget set_state_machine, get_state_machine

static func getID():
	return("missing id")

func set_target(target):
	_target=target

func get_target():
	return(_target)

func is_active_state() -> bool:
	return fsm.current_state == self and fsm.active

func reset_timer() -> void:
	_timer = 0.0

	# Reset all timers and re-register them to
	# allow randomized values to work correctly
	_timers.clear()
	on_timers_register()


func register_timer(method : String, timeout : float, timeout_end : float = 0) -> void:
	var timer_at : float = timeout
	if timeout_end:
		randomize()
		timer_at = rand_range(timeout, timeout_end)
	_timers[timer_at] = method

func set_state_machine(sm):
	fsm=sm

func get_state_machine():
	return(fsm)
	
func _ready() -> void:
	if Engine.editor_hint:
		set_process_input(false)
		set_process(false)
		set_physics_process(false)
	else:
		on_ready()
		on_timers_register()

func _process(delta : float) -> void:
	_timer += delta
	_timers = _dispatch_timers()

func _dispatch_timers() -> Dictionary:
	var next_timers : Dictionary = {}
	for timer in _timers.keys():
		var timer_executed : bool = false

		if _timer > timer and is_active_state():
			var method_name : String = _timers[timer]

			if has_method(method_name):
				call(method_name)
				timer_executed = true

			elif method_name.begins_with(AUTO_METHOD_PREFIX):
				var state_name : String = method_name.lstrip(AUTO_METHOD_PREFIX)
				go_to(state_name)
				timer_executed = true

			elif method_name.begins_with(AUTO_TARGET_METHOD_PREFIX):
				var target_method_name : String  = method_name.lstrip(AUTO_TARGET_METHOD_PREFIX)
				_target.call(target_method_name)
				timer_executed = true

		if not timer_executed:
			next_timers[timer] = _timers[timer]

	return next_timers

func _delete_executed_timer(key : float) -> void:
	_timers.erase(key)

# State transition methods
func go_to(state : String) -> void:
	emit_signal("go_to", state)

func go_to_previous() -> void:
	go_to(fsm.PREVIOUS)

# Behaviors to override
func on_timers_register() -> void:
	pass

func on_ready() -> void:
	pass

# NOTE: leaving 'target' not typed to avoid errors when
#		using typing in the extended scripts
func on_enter(target) -> void:
	pass

func on_exit(target) -> void:
	pass

func on_input(target, event : InputEvent) -> void:
	pass

func on_process(target, delta : float) -> void:
	pass

func on_physics_process(target, delta : float) -> void:
	pass

func onGoto(obj): pass
func onInteract(obj): pass
