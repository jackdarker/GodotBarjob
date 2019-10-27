class_name Menu_NPCDialog
extends PopupDialog

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("Done",[TYPE_OBJECT])
	$Panel/GridContainer/Button1.connect("pressed",self,"_on_Button_OK_pressed",[0])
	$Panel/GridContainer/Button2.connect("pressed",self,"_on_Button_OK_pressed",[1])

func _on_Button_OK_pressed():
	self.visible=false
	emit_signal("Done", self)	

func _on_Button_pressed(extra_arg_0):
	pass # Replace with function body.
