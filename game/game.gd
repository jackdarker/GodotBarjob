class_name Game
extends Node
#const StateMachineFactory = preload("res://core/FSM/StateMachineFactory.gd")
const NewCustomer = preload("res://game/State_NewCustomerRequest.gd")
const Dlgwelcome = preload("res://game/Dialogs/DialogTutorial1.gd")
var smf: StateMachineFactory = StateMachineFactory.new()

# Create state machine using a configuration dictionary
var sm = null
var tableArr=[]
var _barkeeper:Barkeeper
var _player:Waitress setget ,getPlayer
var _menu_order:Menu_CustomerOrder setget ,getMenu_Order

func getPlayer():
	return _player
	
func getMenu_Order():
	return _menu_order

# Called when the node enters the scene tree for the first time.
func _ready():
	
	sm = smf.create(
	{"target": self,
	"current_state": "idle",
	"states": [{"id": "idle", "state": S_Idle},
	{"id": "Tut1", "state": S_Welcome},
	{"id": "walk", "state": S_Walk},
	{"id": "placeOrder", "state": S_PlaceOrder},
	{"id": "takeOrder", "state": S_TakeOrder}],
	"transitions": [{"state_id": "idle", "to_states": ["walk","Tut1"]},
	{"state_id": "Tut1", "to_states": ["idle"]},
	{"state_id": "placeOrder", "to_states": ["idle"]},
	{"state_id": "walk", "to_states": ["idle","takeOrder","placeOrder"]},
	{"state_id": "takeOrder", "to_states": ["idle"]}]
	})
	
	_player = get_node("Waitress")
	_barkeeper = get_node("Barkeeper")
	_barkeeper.connect("onClick",sm,"onGoto")
	_barkeeper.connect("WaitressArrived",sm,"onInteract")
	_menu_order = get_node("Menu_Order")
	_menu_order.connect("Done",sm,"onInteract")
	
	
	for table in get_node("Tables").get_children():
		tableArr.push_back(table)
		
	var arrlen=tableArr.size()
	
	for i in range(arrlen):		
		tableArr[i].connect("onClick",sm,"onGoto")
		tableArr[i].connect("WaitressArrived",sm,"onInteract")
		
	sm.transition("Tut1")

func showOrderTakeMenu():
	_menu_order.set_placeOrder(false)
	_menu_order.popup()

func showOrderPlaceMenu():
	_menu_order.set_placeOrder(true)
	_menu_order.popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sm._process(delta)

class S_Idle:
	extends State
	"""
	no customer
	"""
	func onGoto(obj):
		#obj.get_node("Label").set_text("click")
		get_state_machine().get_target().getPlayer().start_movement(obj.position)
		get_state_machine().transition("walk")

class S_Walk:
	extends State
	func onInteract(obj):
		if(obj is Table):
			get_state_machine().transition("takeOrder")
		if(obj is Barkeeper):
			get_state_machine().transition("placeOrder")
		else:
			get_state_machine().transition("idle")

class S_TakeOrder:
	extends State

	func _on_enter_state():
		get_state_machine().get_target().showOrderTakeMenu()

	func onInteract(obj):
		get_state_machine().transition("idle")

class S_PlaceOrder:
	extends State

	func _on_enter_state():
		get_state_machine().get_target().showOrderPlaceMenu()

	func onInteract(obj):
		get_state_machine().transition("idle")
		
class S_Welcome:
	extends State
	var _dlg:DialogScene
	var _dlgMenu
	func _on_enter_state():
		_dlg = Dlgwelcome.new()
		_dlgMenu = get_state_machine().get_target().get_node("Menu_NPCDialog")
		_dlg.connect("stage_changed",_dlgMenu,"stageChanged")
		_dlg.connect("scene_finished",self,"onDone")
		_dlgMenu.init(_dlg)
		_dlgMenu.connect("Choice",self,"onChoice")
		_dlg.start()
		_dlgMenu.popup()
	
	func onChoice(ID:int):
		_dlg._HandleChoice(_dlg.get_ActualStage().get_ID(),ID)
	
	func onDone():
		_dlgMenu.hide()
		get_state_machine().transition("idle")
