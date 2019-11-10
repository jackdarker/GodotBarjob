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

func getPlayer():
	return _player
	
func getMenu_Order():
	return _menu_order

# Called when the node enters the scene tree for the first time.
func _ready():
	_Orders = Orders.new()
	sm_Game=SM_Game.new()
	sm_Game.set_target(self)
	sm_Game.register_state(S_Welcome.new())
	sm_Game.register_state(S_Idle.new())
	sm_Game.register_state(S_PlaceOrder.new())
	sm_Game.register_state(S_TakeOrder.new())
	sm_Game.register_state(S_Walk.new())
	sm_Game.register_state(S_PickupDrinks.new())
	sm_Game.register_state(S_ServeDrinks.new())
	
	_player = get_node("Waitress")
	_barkeeper = get_node("Barkeeper")
	_barkeeper.connect("onClick",sm_Game,"onGoto")
	_barkeeper.connect("WaitressArrived",sm_Game,"onInteract")
	_menu_order = get_node("Menu_Order")
	_menu_order.connect("Done",sm_Game,"onInteract")
	get_node("Button_EndTurn").connect("pressed",self,endTurn())
	
	
	for table in get_node("Tables").get_children():
		tableArr.push_back(table)
		_Orders.createCustomer(table.TableID)
		
	var arrlen=tableArr.size()
	
	for i in range(arrlen):		
		tableArr[i].connect("onClick",sm_Game,"onGoto")
		tableArr[i].connect("WaitressArrived",sm_Game,"onInteract")
		
	sm_Game.transition("Tut1")

func showOrderTakeMenu():
	var customer:Orders.Customer = _Orders.getCustomerForTable(_waitressAtTable.TableID)
	_menu_order.showOrderTakeMenu(customer)

func onOrderTakeMenuDone():
	_Orders.takeOrder(_waitressAtTable.TableID, _menu_order.get_order())
	
func showOrderPlaceMenu():
	_menu_order.showOrderPlaceMenu(_Orders.newOrders)

func onOrderPlaceMenuDone():
	var _order:Orders = _menu_order.get_order()
	if(_order != null):
		_Orders.waitingOrders.append(_order)



func endTurn():
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
			go_to("takeOrder")
		if(obj is Barkeeper):
			go_to("placeOrder")
		else:
			go_to("idle")

class S_TakeOrder:
	extends State
	static func getID():
		return("takeOrder")
		
	func on_enter(target) -> void:
		get_target().showOrderTakeMenu()

	func onInteract(obj):
		get_target().onOrderTakeMenuDone()
		go_to("idle")

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
		go_to("idle")

class S_ServeDrinks:
	extends State
	static func getID():
		return("serveDrinks")
		
	func on_enter(target) -> void:
		get_target().showServeDrinkMenu()

	#called when Order got placed
	func onInteract(obj):
		get_target().onServeDrinkMenuDone()
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
		go_to("idle")
