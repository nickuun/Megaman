extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("pause"):
		var pauseState = !get_tree().paused
		get_tree().paused = pauseState
		visible = pauseState


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
