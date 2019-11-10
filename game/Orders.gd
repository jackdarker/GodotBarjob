class_name Orders
extends Node

var rng = RandomNumberGenerator.new()
var drinks = ["Wine", "Beer", "Shot", "Coffee"]
var newOrders = []	#Waitress collected these orders now 
var waitingOrders = []	#orders waiting for preparing at bar
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
	
func takeOrder(TableID:int, order:Order):
	if(order!=null):
		newOrders.push_back(order)
		var customer = getCustomerForTable(TableID)
		customer._placedOrder=customer._newOrder
		customer._newOrder=null
	pass


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

func getCustomerForTable(table:int):
	var customer:Customer = null
	if(actualCustomers.has(table)):
		customer = actualCustomers[table]
	return(customer)

func getNewOrderFromCustomer(customer:Customer):
	return(customer._newOrder)

func getPlacedOrderFromCustomer(customer:Customer):
	return(customer._placedOrder)

#deletes the placed order which will trigger a new order or quit
func satisfyCustomer(customer:Customer):
	customer._placedOrder = null

class Order:
	var _custID:int
	var _Drinks = []

class Customer:
	var _custID:int
	var _tableID:int
	var _newOrder:Order = null
	var _placedOrder:Order = null

	
	