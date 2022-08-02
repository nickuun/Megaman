extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var motion = Vector2(0,0)
const gravityOverride = 1.2
var collidingBodies
var rng = RandomNumberGenerator.new()
var bounceTime = 0
var canFall = true
onready var timer = $Timer

func _ready():
	rng.randomize()
	var speed = rng.randf_range(5, 20)
	bounceTime = rng.randf_range(0.3, 0.6)
	$AnimatedSprite.speed_scale = speed*0.1
	
func _process(delta):
	
	if(!is_on_floor() and canFall ):
		if motion.y < 100:
			motion.y += 10
	
	if get_slide_count() > 0 and (bounceTime > 0.009):
		var collision = get_slide_collision(0)
		if collision != null:
			setBounceTime()
			motion = motion.bounce(collision.normal) # do ball bounce

	
	move_and_slide(motion, Vector2.UP, 4, 8 , false)

func _on_Area2D_body_entered(body):
	if("Player" in body.name):
		body.coinCollect()
		$Particles2D.emitting = true
		motion.y += 10
		timer.set_wait_time(1)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")
		$Particles2D.emitting = false
		self.queue_free()
		

func setBounceTime():
	$AudioStreamPlayer.play()
	canFall = false
	timer.set_wait_time(bounceTime)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	bounceTime = bounceTime * 0.7
	
	canFall = true
