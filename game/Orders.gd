class_name Orders
extends Node

var rng = RandomNumberGenerator.new()
var drinks = ["Wine", "Beer", "Shot", "Coffee"]

var newOrders = []	#Waitress collected these orders now 
var waitingOrders = []	#orders waiting at bar for preparing 
var preppingOrders = [] #orders currently processed by barkeeper
var outOrders = []	#drinks waiting at bar for delivery
var deliveringOrders = [] #drinks carried by waitress
var actualCustomers = {}	#actual active customers; key = tableID

var _maxCustomerID:int=0

func _ready():
	rng.randomize()

func getRandomDrinks():
	var i:int =rng.randi_range(0,4)
	return ([drinks[i]])
	
#collected the orders from customer
func takeOrder(TableID:int):
	var customer = getCustomerForTable(TableID)
	if(customer._newOrder != null):
		customer._placedOrder=customer._newOrder
		newOrders.push_back(customer._placedOrder)
	customer._newOrder=null

#waitress place the orders at bar
func placeOrder(orders):
	if(newOrders.size()<=0):
		return
	for order in newOrders:
		waitingOrders.append(order)
		newOrders.erase(order)

#barkeeper creates drink and place them at bar for pickup
func prepOrder(order:Order):
	for drink in order._Drinks:
		outOrders.append(drink)

	preppingOrders.erase(order)
		
	return
		
#waitress picks up drinks from bar
func pickupOrder(drinks):
	if(drinks != null):
		for drink in drinks:
			deliveringOrders.push_back(drink)
		outOrders.erase(drinks)

#checks if this table already placed an order
func canServeDrinks(table:int)->bool:
	var _customer:Customer =getCustomerForTable(table)
	if(_customer==null):
		return(false)
	return(_customer._placedOrder!=null)

#serve the drinks and calculate tip
func serveDrinks(table:int,drinks)->float:
	var _customer:Customer =getCustomerForTable(table)
	if(_customer==null):
		return(0.0)
	var _order:Order = getPlacedOrderFromCustomer(_customer)
	var _toServe = []
	var _found:int=-1 
	var _i:int=0
	for drink in _order._Drinks:
		_found=deliveringOrders.find_last(drink)
		if(_found>-1):
			deliveringOrders.remove(_found)
			_toServe.push_back(_i)
		_i=_i+1
	
	#tip is reduced depending on number of missing drinks
	var _tip:float = round(_i*_i)
	_i = _i-_toServe.size()
	_tip = max(0,_tip-(_i*_i))		
	
	satisfyCustomer(_customer)
	
	return(_tip)

#deletes the placed order which will trigger a new order or quit
func satisfyCustomer(customer:Customer):
	customer._placedOrder = null

func createCustomer(table:int):
	var customer:=Customer.new()
	_maxCustomerID = _maxCustomerID+1
	customer._custID = _maxCustomerID
	customer._tableID = table
	customer._newOrder = Order.new()
	customer._newOrder._custID = customer._custID
	customer._newOrder._Drinks=getRandomDrinks()
	actualCustomers[table]=customer
	return(customer)

func getCustomerForTable(table:int)->Customer:
	var customer:Customer = null
	if(actualCustomers.has(table)):
		customer = actualCustomers[table]
	return(customer)

func getNewOrderFromCustomer(customer:Customer)->Order:
	return(customer._newOrder)

func getPlacedOrderFromCustomer(customer:Customer)->Order:
	return(customer._placedOrder)

#calcualte time in min between clock (c=b-a)
func calcDeltaTime(a:float, b:float) -> float:
	return(b-a)

class Order:
	var _custID:int
	var _Drinks = []
	var _placeTime:float	#time the order was taken by waitress
	var _preppTime:float	#time the prepping was started 

class Drink:
	var _name:String
	var _imgage:Texture

class Customer:
	var _custID:int
	var _tableID:int
	var _newOrder:Order = null
	var _placedOrder:Order = null

	
	