#interaction with cutomer/bar is done in this popup
class_name Menu_CustomerOrder
extends PopupDialog

enum {ORDER_TAKE , #querying orders from customer
	ORDER_PLACE , #if pushing orders to bar
	ORDER_PICKUP ,#if picking drink from bar
	ORDER_SERVE #serving drink to customer
	}
var _mode:int #see enum above 

#func set_placeOrder(placeOrder:bool):
#	_placeOrder=placeOrder
#
#func get_PlaceOrder():
#	return _placeOrder
	
var _drinks = [] setget ,get_drinks
func get_drinks():
	return(_drinks)
	
#var _order:Orders.Order = null setget ,get_order
#func get_order():
#	return(_order)

#display for customer ordering drinks	
func showOrderTakeMenu(customer:Orders.Customer):
	_mode=ORDER_TAKE
	_drinks = []
	if(customer!=null):
		if(customer._newOrder !=null):
			_drinks = customer._newOrder._Drinks
	self.popup()
	
#display for placing order at bar	
func showOrderPlaceMenu(orders:Orders):
	_mode=ORDER_PLACE
	_drinks = []
	for order in orders.newOrders:
		for drink in order._Drinks:
			_drinks.push_back(drink)
	self.popup()

#display for picking drinks from bar	
func showOrderPickupMenu(orders:Orders):
	_mode=ORDER_PICKUP
	_drinks = []
	for drink in orders.outOrders:
		_drinks.push_back(drink)
	self.popup()

#display for serving drinks to customer	
func showOrderServeMenu(orders:Orders):
	_mode=ORDER_SERVE
	_drinks = []
	for drink in orders.deliveringOrders:
			_drinks.push_back(drink)
	self.popup()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("Done",[TYPE_OBJECT])

func _on_Button_OK_pressed():
	self.visible=false
	for Bt in get_node("Panel/GridContainer").get_children():
		if(Bt.is_visible() && Bt.is_pressed() ):
			_drinks.push_back(Bt.get_text())
			
	emit_signal("Done", self)	

func _on_Menu_Control_about_to_show():
	var i:int=_drinks.size()-1
	for Bt in get_node("Panel/GridContainer").get_children():
		Bt.set_toggle_mode(true)
		Bt.set_disabled(_mode==ORDER_TAKE || _mode==ORDER_PLACE)
		if(i>=0):
			Bt.set_text(_drinks[i]._name)
			Bt.set_icon(_drinks[i]._image)
			Bt.set_visible(true)
		else:
			Bt.set_visible(false)
		i=i-1
	
	match _mode:
		ORDER_TAKE:
			get_node("Panel/Label").set_text("The customer wants...")
		ORDER_PLACE:
			get_node("Panel/Label").set_text("Ordering these drinks from barkeeper:")
		ORDER_PICKUP:
			get_node("Panel/Label").set_text("What drinks are you picking up from the bar?")
		ORDER_SERVE:
			get_node("Panel/Label").set_text("Select the drink for serving:")
		_:
			get_node("Panel/Label").set_text("The customer wants...")
		
