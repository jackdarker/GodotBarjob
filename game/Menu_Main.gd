extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var next_scene = preload("res://game/Bar1.tscn")
func _on_Button_Start_pressed():
	get_tree().change_scene_to(next_scene)
	
func _on_Button_Exit_pressed():
	# Exit the game
	get_tree().quit()