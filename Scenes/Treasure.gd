extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $AnimatedSprite
var motion = Vector2(0,0)
var closed = true
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")

func _process(delta):
	if(!is_on_floor()):
		motion.y = 100
		move_and_slide(motion, Vector2.UP, 4, 8 , false)


func _on_Area2D_body_entered(body):
	if (("Player" in body.name )and closed):
		sprite.play("interact")


func _on_Area2D_body_exited(body):
	if (("Player" in body.name )and closed):
		sprite.play("default")
