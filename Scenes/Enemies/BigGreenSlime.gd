extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 2
var xSpeed = 7
var ySpeed = 4
var xDirectionPrevious = -1
var xDirection = -1
var yDirection = 1
var motion = Vector2.ZERO
var wait = 6
var holdPos = false

onready var sprite = $AnimatedSprite
onready var timer = $Timer

func destroy(direction):
	health=health -1 
	if(health == 0):
		print("dead")

func _process(delta):
	wait+=delta
	#print(is_on_floor())
	if(xDirectionPrevious != xDirection):
		sprite.flip_h = !sprite.flip_h
		xDirectionPrevious = xDirection
	if(is_on_wall()):
		xDirection *=-1
	if(!is_on_floor()):
		motion.y=100
		
	if(wait > 5):
		if(randi()%9+1 > 5):
			xDirection *= -1
			holdPos = true
			timer.set_wait_time(0.4)
			timer.set_one_shot(true)
			timer.start()
			yield(timer, "timeout")
			holdPos = false
		else:
			xSpeed = (randi()%8+1)
		wait = 0
	
	if(holdPos):
		motion.x = 0
	else:
		motion.x = xSpeed * xDirection
	
		
	#print(delta)
	#print(randi()%10+1)
		
		motion = move_and_slide(motion, Vector2.UP, false,4, 0.785398, false)


#func _process(delta):
#	pass
