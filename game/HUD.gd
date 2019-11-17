class_name HUD
extends Node2D

func _ready():
	pass

func updateTip(total:float):
	get_node("Tip").text = "Tip: {0}$".format(["%0.2f" %total])

func updateClock(total:float):
	#"Hi, {0} v{version}".format({0:"Godette", "version":"%0.2f" % 3.114})
	#convert minutes to something like 21:05
# warning-ignore:integer_division
	var _h:int = int(total) / 60
# warning-ignore:integer_division
	_h = _h % 24
	var _m:int = int(total) % 60
	get_node("Clock").text = "Clock: {0}:{1}".format([_h,"%02d" %_m])
