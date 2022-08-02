extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = $Timer
onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("Shrink")
	timer.set_wait_time(0.4)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
