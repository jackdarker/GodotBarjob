class_name Waitress
extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_movement(goal:Vector2):
	var tween = get_node("Movement")
	tween.interpolate_property(self, "position",
	        self.position, goal, 1,
	        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	get_node("Bubble").play("walk",false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Waitress_area_entered(area):
	var tween = get_node("Movement")
	tween.stop_all()
	get_node("Bubble").play("question",false)
