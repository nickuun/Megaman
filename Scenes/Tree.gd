extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var motion = Vector2(0,0)
const gravityOverride = 1.2
var collidingBodies
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if(!is_on_floor()):
		motion.y = 100
		move_and_slide(motion, Vector2.UP, 4, 8 , false)
