extends KinematicBody2D

onready var screenShaker = $Camera2D/ScreenShaker

#Health Variables
var maxMaxHealth = 10
var maxHealth = 5
var health = 5
var coins = 0
var coinValue = 1
#dmg variables
var jumpDamage = 1
var projectileDamage = 1
var desiredMotionX = 0.0
var desiredMotionY = 0.0

var pushForce = 10
var bloodPush = 100
#Movement Variables
const acceleration = 800 #700
const maxSpeed = 180 #160
const maxFall = 280 #250
const friction = 0.2
const airFriction = 0.01
const gravity = 650 #650
const jumpForce = 1000 #320
var hit = false
var hitDirection = 1
var motion = Vector2.ZERO
var direction = {currentDirection = 1, previousDirection = 0}
var xInput = 0



const CHAIN_PULL = 50
var chain_velocity := Vector2(0,0)

#Scenes and Scripts
var cam = preload("res://Scenes/ScreenShaker.gd")
onready var sprite = $AnimatedSprite
onready var hitbox = $CollisionShape2D
onready var frontMiddleRay = $FrontMiddleRay
onready var camera = $Camera2D
onready var ray = $Gun/RayCast2D
onready var chain = $Chain
onready var timer = $Timer
onready var coinPickupSound = $YSort/CoinPickup


signal healthChanged(value)
signal coinsChanged(value)

func increaseProjectileDamage(amount):
	projectileDamage = projectileDamage + amount

func getDirection():
	return direction.currentDirection

func coinCollect():
	coinPickupSound.play()
	coins = coins + coinValue
	emit_signal("coinsChanged",coins)

func position():
	var returnState = self.get_position()
	return(returnState)

func heal(amount):
	health = health + amount
	emit_signal("healthChanged",health)

func hit(direction):
	hit = true
	health = health - 1
	emit_signal("healthChanged",health)
	hitDirection = direction
	timer.set_wait_time(0.45)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	if(health < 1):
		get_tree().reload_current_scene()
	hit=false

func bounce():
	motion.y = 0.8*(-jumpForce)

func _input(event: InputEvent) -> void:			
	if (Input.is_action_just_pressed("hook") and !($Chain.hooked or $Chain.flying)):
		if(direction.currentDirection >= 0):
				$Chain.shoot((to_local(get_global_mouse_position())))
		else:
				#INVERSE VECTOR HERE FOR GRAPPLE DIRECTION
				$Chain.shoot((to_local(get_global_mouse_position())) * Vector2(-1,1))
	elif(Input.is_action_just_released("hook")):
			# We released the mouse -> release()
			if $Chain.enemyGrabbed:
				$Chain.releaseEnemy()
			else:
				$Chain.release()
			#if hook has enemy, release him

func canSlide():
	if(frontMiddleRay.is_colliding() and xInput != 0):
		return true
	else: 
		return false

var t = 0.4
var previousXpos
func _physics_process(delta):
	var target = self.global_position
	var mid_x = ((target.x + (direction.currentDirection * 1)) + (get_global_mouse_position().x)) / 2
	var mid_y = (target.y + get_global_mouse_position().y) / 2
	var tempPostion = self.global_position.linear_interpolate(Vector2(mid_x,mid_y), t)
	camera.global_position = lerp(camera.global_position, tempPostion, 0.5 )
	
	#camera.global_position = Vector2(mid_x, mid_y)
	#var tempPostion = ((sprite.global_position + (get_global_mouse_position()))/2)#ray.get_collision_point()
	#camera.global_position = lerp(camera.global_position, tempPostion, 0.1 )
	#camera.global_position = tempPostion
	
	#TESTING END
	if(!hit):
		xInput = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
		if(xInput != 0): 
			if(is_on_floor()):
				motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
				sprite.play("run")
			else: 
				if(canSlide()):
					
					sprite.play("wallSlide")
					motion.y = lerp(motion.y , 1 , friction)
				else:
					
					sprite.play("jump")
			#motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
			motion.x += xInput * acceleration * delta
			
			
			if(xInput < 0): #GOING LEFT
				direction.previousDirection = direction.currentDirection
				direction.currentDirection = -1
			
			else: #GOING RIGHT
				direction.previousDirection = direction.currentDirection
				direction.currentDirection = 1
			
			if(direction.previousDirection != direction.currentDirection):
				self.scale.x *= -1
				#$Trail.scale.x *= -1
				$Trail.scale.y *= -1
			
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
				
			if (Input.is_action_just_pressed("ui_up")):
				motion.y = -jumpForce
		else:
			if (canSlide()):
				if (Input.is_action_just_pressed("ui_up")):
					motion.y = (-jumpForce * 4/5)
					motion.x = lerp(motion.x,(-1 * (direction.currentDirection * 420)), 0.5)
			else:
				if xInput == 0:
					motion.x = lerp(motion.x , 0 , airFriction)
				if (Input.is_action_just_released("ui_up") and motion.y < -jumpForce/2):
					motion.y = -jumpForce/2
		
		
		if $Chain.hooked and !$Chain.enemyGrabbed:
			motion.x = clamp(motion.x, -(maxSpeed +40), (maxSpeed +40))
			# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
			chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
			if chain_velocity.y > 0:
				# Pulling down isn't as strong
				chain_velocity.y *= 0.55
			else:
				# Pulling up is stronger
				chain_velocity.y *= 1.65
		else:
			motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
			chain_velocity = Vector2(0,0)
		motion.x = motion.x + (chain_velocity.x * direction.currentDirection)
		if(-230 < motion.y and motion.y < 230):
			motion.y = motion.y + (chain_velocity.y * 0.2)
		else:
			if(motion.y < -230):
				motion.y = -229  + (chain_velocity.y * 0.2)
			else:
				motion.y = 229 + (chain_velocity.y * 0.2)
	else:
		motion.x= motion.x + hitDirection * 12	
		motion.y = lerp(motion.y,gravity,0.022
		)
	
	#motion = move_and_slide(motion, Vector2.UP)
	
	motion = move_and_slide(motion, Vector2.UP, false,4, 0.785398, false)
#	move_and_slide ( motion,Vector2( 0, -1 ),false, 4,0.785398,true )
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		#print("my pos is:" , self.position.y)
		#print("Box pos is:" , collision.position.y)
		if(("BloodParticle" in collision.collider.name)):
			collision.collider.apply_central_impulse(-collision.normal * bloodPush)
		if ("object" in collision.collider.name and (frontMiddleRay.is_colliding())):
			collision.collider.apply_central_impulse(-collision.normal * pushForce)

