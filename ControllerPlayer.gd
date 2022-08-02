extends KinematicBody2D

onready var screenShaker = $Camera2D/ScreenShaker

const acceleration = 550
const maxSpeed = 90
const friction = 0.15
const airFriction = 0.1
const gravity = 350
const jumpForce = 190

var motion = Vector2.ZERO

var direction = {currentDirection = 1, previousDirection = 0}

var xInput = 0

var cam = preload("res://Scenes/ScreenShaker.gd")

onready var sprite = $AnimatedSprite
onready var hitbox = $CollisionShape2D
onready var frontMiddleRay = $FrontMiddleRay
onready var camera = $Camera2D

func canSlide():
	
	if(frontMiddleRay.is_colliding() and xInput != 0):
		return true
	else: 
		return false

func _physics_process(delta):	
	motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
	xInput = Input.get_action_strength("controller_right") - Input.get_action_strength("controller_left")
	
	if(xInput != 0): 
		if(is_on_floor()):
			sprite.play("run")
		else: 
			if(canSlide()):
				sprite.play("wallSlide")
				motion.y = lerp(motion.y , 1 , friction)
			else:
				sprite.play("jump")
		motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
		motion.x += xInput * acceleration * delta
		
		
		if(xInput < 0): #GOING LEFT
			direction.previousDirection = direction.currentDirection
			direction.currentDirection = -1
		
		else: #GOING RIGHT
			direction.previousDirection = direction.currentDirection
			direction.currentDirection = 1
		
		if(direction.previousDirection != direction.currentDirection):
			self.scale.x *= -1
		
	else:
		if(!is_on_floor()):
			#Engine.time_scale = 0.5
			sprite.play("jump")
		else: 
			sprite.play("idle")

	motion.y += (gravity * delta)
	
	if (is_on_floor()):
		if(xInput == 0):
			motion.x = lerp(motion.x , 0 , friction)
			
		if (Input.is_action_just_pressed("controller_jump")):
			motion.y = -jumpForce
	else:
		if (canSlide()):
			if (Input.is_action_just_pressed("controller_jump")):
				motion.y = (-jumpForce * 2/3)
				motion.x = (-1 * (direction.currentDirection * 400))
		else:
			if xInput == 0:
				motion.x = lerp(motion.x , 0 , airFriction)
			if (Input.is_action_just_released("controller_jump") and motion.y < -jumpForce/2):
				motion.y = -jumpForce/2

	motion = move_and_slide(motion, Vector2.UP)
	
	
	


func _on_Player_mouse_entered():
	print("test")
