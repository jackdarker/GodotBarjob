extends Path2D

export(NodePath)  var From : NodePath
export(NodePath)  var To : NodePath
export(float)  var Weight : float

func _ready():
	#if Engine.editor_hint:
		
	pass
