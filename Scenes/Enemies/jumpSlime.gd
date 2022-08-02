extends KinematicBody2D


onready var Player = get_parent().get_parent().get_node("Player")

var vel = Vector2(0, 0)

var grav = 1800
var max_grav = 250
var max_health = 7
var health = max_health
var react_time = 480
var prevDir = 0
var dir = 0
var next_dir = 0
var next_dir_time = 0
var jumps = 5
var maxJumps = 5
var jumpCounterTime = 0
var jumpCounterMaxTime = 1.5
var knockback = Vector2.ZERO
var knocked = false
var knockVelocity = 190 #150
var knockDuration = 0.3 #0.2
var hitDirection
var hooked = false
var hookTipPosition
var previousPrint
var alive = true

var next_jump_time = -1

var target_player_dist = 65
onready var timer = $Timer
onready var hpbar = $HealthDisplay
signal OnDeath(WhoDied)

func pull(tipPos):
	hookTipPosition = tipPos
	hooked = true
	if tipPos != previousPrint:
		previousPrint = tipPos

func setKnock(direction):
	knocked = true
	hitDirection = direction
	timer.set_wait_time(knockDuration)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	knocked = false

func applyDmg(damage):
	$GooSpat.splat()
	health = health -damage
	$FCTManager.show_value(12,damage, null)
	hpbar.update_healthbar(health)
	if health <= 0:
		
		alive = false
		timer.set_wait_time(0.5)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")
		$BloodSplatterComponent.splatter()
#emit_signal("OnDeath",self)
		queue_free()

func destroy(direction, damage):
	setKnock(direction)
	applyDmg(damage)

func _ready():
	set_process(true)
	
func attack():
	pass

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func _process(delta):
	
		
	if(jumpCounterTime > jumpCounterMaxTime) and (jumps < maxJumps):
		jumps = jumps + 1
		jumpCounterTime = 0
	else:
		jumpCounterTime += delta

	if Player.position.x < position.x - target_player_dist:
		$AnimatedSprite.scale.x = 1
		set_dir(-1)
	elif Player.position.x > position.x + target_player_dist :
		$AnimatedSprite.scale.x = -1
		set_dir(1)
	else:
		set_dir(0)

	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir

	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if (Player.position.y < position.y - 64) and (jumps > 0):
			jumps = jumps -1
			$AnimatedSprite.play("jump")
			vel.y = -400
		next_jump_time = -1

	vel.x = dir * 150

	if Player.position.y < position.y - 1 and next_jump_time == -1:
		next_jump_time = OS.get_ticks_msec() + react_time

	vel.y += grav * delta;
	if vel.y > max_grav:
		vel.y = max_grav

	if is_on_floor() and vel.y > 0:
		vel.y = 0
		$AnimatedSprite.play("default")
	
	if(knocked):	
		vel = hitDirection * knockVelocity
		vel = vel.move_toward(Vector2.ZERO, knockVelocity * (delta * 0.5))
		vel = move_and_slide(vel)
		
	if(!hooked):
		
		vel = move_and_slide(vel, Vector2(0, -1))
	else:
		
		var distance = pow(self.global_position.x - previousPrint.x,2) + pow(self.global_position.y - previousPrint.y,2);
		if (distance < 500):
			self.global_position = lerp(self.global_position , previousPrint, 0.8)
		
func _on_topchecker_body_entered(body):
	if("Player" in body.name):
		body.bounce()
		destroy(Vector2.DOWN, body.jumpDamage)
