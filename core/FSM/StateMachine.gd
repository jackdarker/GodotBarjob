
class_name StateMachine
extends Node 
# The state machine's target object, node, etc
var _target_node = null setget set_target, get_target

const PREVIOUS := 'previous'

var active : bool = true
var initial_state : String = ''
var active_state : String = ''

# Dictionary of states by state id
var _states_map : Dictionary = {}
var _states_stack : Array = ['']

# Dictionary of valid state transitions

# Reference to current state object
var current_state setget transition, get_current_state

func set_target(target):
	"""
	Sets the target object, which could be a node or some other object that the states expect
	"""
	_target_node = target
	if(!_states_map.has(DefaultState.getID())):
		register_state(DefaultState.new())
	for s in _states_map.values(): s.set_target(target)

func get_target():
	"""
	Returns the target object (node, object, etc)
	"""
	return _target_node

func get_states():
	"""
	Returns the dictionary of states
	"""
	return _states_map

func get_current_state():
	"""
	Returns the string id of the current state
	"""
	return current_state


func register_state(state):
	"""
	Add a state to the states dictionary
	"""
	_states_map[state.getID()] = state
	state.set_state_machine(self)
	
	if _target_node: state.set_target(_target_node)
	

func get_state(state_id):
	"""
	Return the state from the states dictionary by state id if it exists
	"""
	if state_id in _states_map:
		return _states_map[state_id]
	else:
		print("Cannot get state, invalid state: ", state_id)


func transition(state : String) -> void:
	if state and not _states_stack.front() == state:
		if current_state:
			current_state.on_exit(_target_node)

		if state == PREVIOUS:
			_states_stack.pop_front()

		else:
			var next_state  = _states_map.get(state)

			if not next_state.state_type == next_state.StateType.PUSH:
				_states_stack.pop_front()

			_states_stack.push_front(state)

		# Check if the state as connected and disconnect it
		if current_state and current_state.is_connected('go_to', self, '_on_State_go_to'):
			current_state.disconnect('go_to', self, '_on_State_go_to')

		current_state = _states_map.get(_states_stack.front())
		active_state = state # Update state name

		# Register the signal in the new state
		current_state.connect('go_to', self, '_on_State_go_to')

		current_state.on_enter(_target_node)

		if not state == 'previous':
			# Don't reset timers if coming from a 'PUSH' StateType
			current_state.reset_timer()

# External use to set state in a similar way from State node
func go_to(state : String) -> void:
	self.current_state = state

# Signal bind
func _on_State_go_to(state : String) -> void:
	go_to(state)

func in_states(states : Array = []) -> bool:
	return active_state in states

func get_all_states() -> Array:
	return _states_map.keys()

func _ready() -> void:
	if not Engine.editor_hint:
		self.current_state = initial_state

	else:
		set_process(false)
		set_process_input(false)
		set_physics_process(false)
		
func _input(event : InputEvent) -> void:
	if active and current_state:
		current_state.on_input(_target_node, event)

func _process(delta : float) -> void:
	if active and current_state:
		current_state.on_process(_target_node, delta)

func _physics_process(delta : float) -> void:
	if active and current_state:
		current_state.on_physics_process(_target_node, delta)

