extends Node
const StateMachineFactory = preload("res://core/FSM/StateMachineFactory.gd")
const NewCustomer = preload("res://game/State_NewCustomerRequest.gd")
var smf: StateMachineFactory = StateMachineFactory.new()

# Create state machine using a configuration dictionary
var sm = null

# Called when the node enters the scene tree for the first time.
func _ready():
	smf.test()
	sm = smf.create()
#	{"target": self,
#	"current_state": "patrol",
#	"states": [{"id": "idle", "state": NewCustomer},
#	{"id": "patrol", "state": NewCustomer}],
#	"transitions": [{"state_id": "idle", "to_states": ["patrol"]},
#	{"state_id": "patrol", "to_states": ["idle"]}]})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sm._process(delta)
