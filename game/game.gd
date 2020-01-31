class_name Game
extends Node
#const StateMachineFactory = preload("res://core/FSM/StateMachineFactory.gd")
const NewCustomer = preload("res://game/State_NewCustomerRequest.gd")
const Dlgwelcome = preload("res://game/Dialogs/DialogTutorial1.gd")

var sm_Game:StateMachine = null
var _Orders:Orders
var tableArr=[]
var _waitressAtTable = null
var _barkeeper:Barkeeper
var _player:Waitress setget ,getPlayer
var _menu_order:Menu_CustomerOrder setget ,getMenu_Order
var _hud:HUD = null
var _totalTip:float=0.0
var _clock:float=0.0	#in min since midnight

func getPlayer():
	return _player
	
func getMenu_Order():
	return _menu_order

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("updateTip",[TYPE_OBJECT])
	add_user_signal("updateClock",[TYPE_OBJECT])
	#setup of main game state machine
	_Orders = Orders.new()
	sm_Game=SM_Game.new()
	sm_Game.set_target(self)
	sm_Game.register_state(S_Welcome.new())
	sm_Game.register_state(S_TurnEnd.new())
	sm_Game.register_state(S_Start.new())
	sm_Game.register_state(S_Idle.new())
	sm_Game.register_state(S_PlaceOrder.new())
	sm_Game.register_state(S_TakeOrder.new())
	sm_Game.register_state(S_Walk.new())
	sm_Game.register_state(S_PickupDrinks.new())
	sm_Game.register_state(S_ServeDrinks.new())
	
	#fetch some nodes for access from game class
	_player = get_node("Waitress")
	_barkeeper = get_node("Barkeeper")
	_menu_order = get_node("Menu_Order")
	_hud = get_node("HUD")

	_barkeeper.init(_Orders)
	#connect events
	_barkeeper.connect("onClick",sm_Game,"onGoto")
	_barkeeper.connect("WaitressArrived",sm_Game,"onInteract")
	get_node("Button_EndTurn").connect("pressed",self,"endTurn")
	_menu_order.connect("Done",sm_Game,"onInteract")
	self.connect("updateTip",_hud,"updateTip")
	self.connect("updateClock",_hud,"updateClock")
	self.connect("updateClock",_barkeeper,"updateClock")
	
	for table in get_node("Tables").get_children():
		tableArr.push_back(table)
		table.connect("onClick",sm_Game,"onGoto")
		table.connect("WaitressArrived",sm_Game,"onInteract")
		_Orders.createCustomer(table.TableID)

	#start game	
	#sm_Game.transition("Tut1")	#game tutorial intro
	sm_Game.transition(S_Start.getID())
	
func showOrderTakeMenu():
	var _customer = _Orders.getCustomerForTable(_waitressAtTable.TableID)
	_menu_order.showOrderTakeMenu(_customer)

func onOrderTakeMenuDone():
	_Orders.takeOrder(_waitressAtTable.TableID)
	
func showOrderPlaceMenu():
	_menu_order.showOrderPlaceMenu(_Orders)

func onOrderPlaceMenuDone():
	_Orders.placeOrder(_Orders.newOrders)
	
func showPickupDrinkMenu():
	_menu_order.showOrderPickupMenu(_Orders)

func onPickupDrinkMenuDone():
	_Orders.pickupOrder(_menu_order.get_drinks())

func showServeDrinkMenu():
	_menu_order.showOrderServeMenu(_Orders)

func onServeDrinkMenuDone():
	_totalTip = _totalTip + _Orders.serveDrinks(_waitressAtTable.TableID,_menu_order.get_drinks())
	emit_signal("updateTip",_totalTip)

func isReadyToServe()->bool:
	return(_Orders.canServeDrinks(_waitressAtTable.TableID))

func startGame():
	_totalTip=0
	_clock=1140	#19h*60min
	emit_signal("updateTip",_totalTip)
	emit_signal("updateClock",_clock)
	pass

func endTurn():
	_clock = _clock + 10
	emit_signal("updateClock",_clock)
	pass

class SM_Game:
	extends StateMachine
	func onGoto(obj):
		if current_state.has_method("onGoto"): current_state.onGoto(obj)
	
	func onInteract(obj):
		if current_state.has_method("onInteract"): current_state.onInteract(obj)

class S_Idle:
	extends State
	
	static func getID():
		return("idle")
		
	func onGoto(obj):
		#obj.get_node("Label").set_text("click")
		get_target().getPlayer().start_movement(obj.position)
		go_to("walk")

class S_Walk:
	extends State
	static func getID():
		return("walk")
		
	func onInteract(obj):
		if(obj is Table):
			get_target()._waitressAtTable = obj
			if(get_target().isReadyToServe()):
				go_to("serveDrinks")
			else:
				go_to("takeOrder")
		else:
			if(obj is Barkeeper):
				go_to("placeOrder")
			else:
				go_to("idle") #should never get here

class S_TakeOrder:
	extends State
	static func getID():
		return("takeOrder")
		
	func on_enter(target) -> void:
		get_target().showOrderTakeMenu()

	func onInteract(obj):
		get_target().onOrderTakeMenuDone()
		go_to("endTurn")

class S_PlaceOrder:
	extends State
	static func getID():
		return("placeOrder")
		
	func on_enter(target) -> void:
		get_target().showOrderPlaceMenu()

	#called when Order got placed
	func onInteract(obj):
		get_target().onOrderPlaceMenuDone()
		go_to("pickupDrinks")

class S_PickupDrinks:
	extends State
	static func getID():
		return("pickupDrinks")
		
	func on_enter(target) -> void:
		get_target().showPickupDrinkMenu()

	#called when Order got placed
	func onInteract(obj):
		get_target().onPickupDrinkMenuDone()
		go_to("endTurn")

class S_ServeDrinks:
	extends State
	static func getID():
		return("serveDrinks")
		
	func on_enter(target) -> void:
		get_target().showServeDrinkMenu()

	#called when Order got placed
	func onInteract(obj):
		get_target().onServeDrinkMenuDone()
		go_to("endTurn")
		
class S_Start:
	extends State
	static func getID():
		return("start")
		
	func on_enter(target) -> void:
		get_target().startGame()
		go_to("idle")

class S_TurnEnd:
	extends State
	static func getID():
		return("endTurn")
		
	func on_enter(target) -> void:
		get_target().endTurn()
		go_to("idle")

class S_Welcome:
	extends State
	var _dlg:DialogScene
	var _dlgMenu
	static func getID():
		return("Tut1")
		
	func on_enter(target) -> void:
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
		go_to("start")
