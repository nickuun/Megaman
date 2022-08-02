extends KinematicBody2D

var velocity = Vector2()
export var direction = -1 #Startts facing left
var speed = 50
var gravity = 20
var alive = true
var invincible = false
var hitting = false
var max_health = 3

onready var animatedSprite = $AnimatedSprite
onready var floorChecker = $FloorChecker
onready var collisionSghape = $CollisionShape2D
onready var timer = $Timer

func _ready():
	if(direction == 1):
		animatedSprite.flip_h = true
	floorChecker.position.x = collisionSghape.shape.get_extents().x * direction

	#set_modulate(Color(1,0.3,0.3,0.3))
	#This can be used to manipulate spirite colours
	pass
	
func flip(): #turn around teh Pig
	direction *= -1
	animatedSprite.flip_h = !(animatedSprite.flip_h)
	floorChecker.position.x = collisionSghape.shape.get_extents().x * direction
	
func _physics_process(delta):
	if alive:
		if(!hitting):
			animatedSprite.play("Run")
			if(is_on_wall() or (not(floorChecker.is_colliding()) and is_on_floor())):
				flip()
			
			velocity.y += gravity
			velocity.x = direction * speed
		else:
			velocity.x = lerp(velocity.x, 0, 0.5)
			velocity.y= -10
			animatedSprite.play("Attack")
		velocity = move_and_slide(velocity, Vector2.UP, 4, 8 , false)
	else:
		if max_health <= 0:
			animatedSprite.play("Dead")
			var t = Timer.new()
			t.set_wait_time(6)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			self.queue_free()
		else:
			animatedSprite.play("Hit")

func destroy(direction,damage):
	if(alive == true):
		velocity = Vector2.ZERO
		alive = !alive
		max_health = max_health - damage
		$FCTManager.show_value(12,damage, null)
		$HealthDisplay.update_healthbar(max_health)
		timer.set_wait_time(0.4)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")

	
		if(max_health < 1):
			$BloodSplatterComponent.splatter()
			set_collision_layer_bit(5,false)
			set_collision_mask_bit(0, false)
			$topchecker.set_collision_layer_bit(5,false)
			$topchecker.set_collision_mask_bit(0,false)
		else:
			alive = !alive

func _on_topchecker_body_entered(body):
	if("Player" in body.name):
		body.bounce()
		destroy(Vector2.DOWN, body.jumpDamage)


func _on_SideChecker_body_entered(body):
	if("Player" in body.name and alive  and is_on_floor()): #and !hitting
		hitting = true
		if((body.position().x < self.get_position().x)and (direction == 1)):
			flip()
		else:
			if((body.position().x > self.get_position().x) and (direction == -1)):
				flip()
		body.hit(direction)
		#get_tree().change_scene("res://Scenes/World.tscn")
		#RESET WORLD
		
		timer.set_wait_time(0.5)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")
		hitting = false
	else:
		if("object" in body.name and alive):
			flip()
		#get_tree().change_scene("res://Scenes/World.tscn")

