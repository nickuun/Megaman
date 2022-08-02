extends KinematicBody2D


const GRAVITY = 200.0
var velocity = Vector2()
var motionX = 0
var motionY = 0

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	velocity.x += delta * motionX
	velocity.y += delta * motionY

	var motion = velocity * delta
	move_and_collide(motion)
