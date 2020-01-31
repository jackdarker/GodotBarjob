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

#func _on_TextureButton_pressed():
#	emit_signal("onClick", self)	

func _on_Button_In_pressed():
	emit_signal("onClick", self)
	if(_alreadyThere):	#workaround if waitress already ar target
		emit_signal("WaitressArrived", self)

var _alreadyThere:bool = false
func _on_Barkeeper_area_entered(area):
	_alreadyThere= true
	get_node("RichTextLabel").set_bbcode(("[img]{str}[/img]").format({"str":Resources.Path_WineRed})  )
	get_node("Text").set_bbcode(Resources.Path_WineRed )
	emit_signal("WaitressArrived", self)

func _on_Barkeeper_area_exited(area):
	_alreadyThere = false

func updateClock(total:float):
	sm.updateClock(total)
	#for drink in _orders.outOrders

class SM_Barkeeper:
	extends StateMachine
	func updateClock(obj):
		if current_state.has_method("updateClock"): current_state.updateClock(obj)

class S_Idle:
	extends State
	
	static func getID():
		return("idle")
	
	#check if there are waiting orders 	
	func updateClock(total:float):
		var _orders:Orders = get_target()._orders
		if(_orders.waitingOrders.size()<=0):
			return
		
		for order in _orders.waitingOrders:
			order._preppTime = total+10	#todo: fixed time?
			_orders.preppingOrders.append(order)
			_orders.waitingOrders.erase(order)
		
		go_to("working")
		return


class S_Working:
	extends State
	
	static func getID():
		return("working")
	
	#prep the drinks
	func updateClock(total:float):
		var _orders:Orders = get_target()._orders
		if(_orders.preppingOrders.size()<=0):
			go_to("idle")
			return
			
		for order in _orders.preppingOrders:
			var _ready:bool = _orders.calcDeltaTime(order._preppTime,total)>0
			if(_ready):
				_orders.prepOrder(order)
		
		return