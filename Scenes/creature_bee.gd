extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var xSpeed = 7
var ySpeed = 4
var xDirectionPrevious = -1
var xDirection = -1
var yDirection = 1
var motion = Vector2.ZERO
var wait = 6

onready var sprite = $AnimatedSprite

func destroy(direction):
	print("ouch")
	self.queue_free()

func _process(delta):
	wait+=delta
	#print(is_on_floor())
	if(xDirectionPrevious != xDirection):
		sprite.flip_h = !sprite.flip_h
		xDirectionPrevious = xDirection
	if(is_on_floor()):
		yDirection *= -1
	if(is_on_wall() or is_on_ceiling()):
		yDirection *=-1
		xDirection *=-1
	if(wait > 5):
		if(randi()%9+1 > 5):
			yDirection *= -1
		if(randi()%9+1 > 5):
			
			xDirection *= -1
		ySpeed = (randi()%9+1)*0.5
		xSpeed = (randi()%6+1)*2
		wait = 0
	
	motion.y = ySpeed * yDirection
	motion.x = xSpeed * xDirection
	#print(delta)
	#print(randi()%10+1)
		
	motion = move_and_slide(motion, Vector2.UP, false,4, 0.785398, false)


#func _process(delta):
#	pass
