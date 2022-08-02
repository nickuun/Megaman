extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var xSpeed = 35
var xDirectionPrevious = -1
var xDirection = -1
var motion = Vector2.ZERO
var wait = 6
var gravity = 150
var waiting = true

var hooked = false
var hookTipPosition
var previousPrint
var alive = true
var max_health = 1

signal OnDeath(WhoDied)

onready var sprite = $AnimatedSprite
onready var deathSound = $YSort/pop
onready var hurtSound = $YSort/Hurt
onready var timer = $Timer
var hasPop = false
var coin_scene = preload("res://Scenes/coin.tscn")
var knocked = false
var hitDirection
var knockVelocity = 100

func pull(tipPos):
	hookTipPosition = tipPos
	hooked = true
	if tipPos != previousPrint:
		previousPrint = tipPos

func setKnock(direction):
	knocked = true
	hitDirection = direction
	timer.set_wait_time(0.1)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	knocked = false

func pop():
	if(!hasPop):
		sprite.play("death")
		emit_signal("OnDeath",self)
		var t = Timer.new()
		hasPop = true
		deathSound.play()	
		t.set_wait_time(randi()%1+1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()

		queue_free()

func destroy(direction,damage):
	sprite.play("hurt")
	if(alive == true):
		$GooSpat.splat()
		setKnock(direction)
		hurtSound.play()
		xSpeed = Vector2.ZERO
		alive = !alive
		max_health = max_health - damage
		$FCTManager.show_value(12,damage, null)
		$HealthDisplay.update_healthbar(max_health)
		timer.set_wait_time(0.4)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")


	
		if(max_health < 1):
			set_collision_layer_bit(5,false)
			set_collision_mask_bit(0, false)
			$topchecker.set_collision_layer_bit(5,false)
			$topchecker.set_collision_mask_bit(0,false)
			pop()
		else:
			alive = !alive
	
func attack():
	sprite.play("attack")
	timer.set_wait_time(0.15)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	sprite.play("default")
	print("attak")

func drop_loot():
	var coin = coin_scene.instance()
	coin.global_position = global_position
	get_tree().get_root().add_child(coin)

func _ready():
	sprite.play("idle")
	var t = Timer.new()
	t.set_wait_time(randi()%5+1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	waiting = false
	sprite.play("default")
	#drop_loot()
	#xSpeed =( randi()%12+1) * 4
	#if(xSpeed < 15):
	#	xSpeed = 16

func _process(delta):
	
	if(xDirectionPrevious != xDirection and !hooked):
		sprite.flip_h = !sprite.flip_h
		xDirectionPrevious = xDirection
	if(is_on_wall()):
		xDirection *=-1
	if(!is_on_floor()):
		motion.y = gravity
		
	if(!waiting and alive):
		motion.x = xSpeed * xDirection		
	else:
		motion.x = 0
		motion.y=0
	
	if(knocked):	
		motion = hitDirection * knockVelocity
		motion = motion.move_toward(Vector2.ZERO, knockVelocity * (delta * 0.5))
		motion = move_and_slide(motion)
		if !is_on_floor():
			motion.y+=gravity
	if(!hooked):
		motion = move_and_slide(motion, Vector2.UP, false,4, 0.785398, false)
	else:
		var distance = pow(self.global_position.x - previousPrint.x,2) + pow(self.global_position.y - previousPrint.y,2);
		if (distance < 500):
			self.global_position = lerp(self.global_position , previousPrint, 0.8)


func _on_topchecker_body_entered(body):
	if("Player" in body.name):
		body.bounce()
		destroy(Vector2.DOWN, body.jumpDamage)

