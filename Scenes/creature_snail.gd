extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const gravity = 300
const speed = 5
onready var sprite = $AnimatedSprite
onready var hitbox = $CollisionShape2D
onready var bottomChecker = $BottomChecker
onready var frontArea = $Area2D
onready var timer = $Timer
var motion = Vector2.ZERO
var stuck = false
var xDirection = -1
var yDirection = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_on_floor()):
		stuck = true	
	
	if(!stuck):
		motion.y += (gravity * delta)
	else:
		stuck = true
		if(yDirection == -1):
			motion.x = xDirection * speed
		else:
			motion.y = xDirection * speed
		
	motion = move_and_slide(motion, Vector2.UP, false,4, 0.785398, false)

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	self.rotation_degrees = round( self.rotation_degrees + 90)
	timer.set_wait_time(0.4)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	yDirection *= -1
	self.rotation_degrees = round(self.rotation_degrees)
	if(( self.rotation_degrees == 180) or (self.rotation_degrees == 0)or (self.rotation_degrees == -180)):
		xDirection *=-1
	#print ("my new roation is:" , self.rotation_degrees)
	#print ("my x dir is:" , xDirection)
	#print ("my y dir is:" , yDirection)
	




func _on_botArea_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if(!bottomChecker.is_colliding() and stuck):
		timer.set_wait_time(0.4)
		timer.set_one_shot(true)
		timer.start()
	
		yield(timer, "timeout")
		#print("fall")
		self.rotation_degrees = round( self.rotation_degrees + 270)
		motion.x = 0
		motion.y = 0
		#if(( self.rotation_degrees == 180) or (self.rotation_degrees == 0)or (self.rotation_degrees == -180)):
		xDirection *= -1
		yDirection *= -1
		if(( self.rotation_degrees == 180) or ( self.rotation_degrees == 360)):
			xDirection *= -1
		self.rotation_degrees = round(self.rotation_degrees)
		#print ("my new roation is:" , self.rotation_degrees)
		#print ("my x dir is:" , xDirection)
		#print ("my y dir is:" , yDirection)
