extends AnimatedSprite

var canFire = true
var bullet_instance = preload("res://Scenes/Bullet.tscn")
var duration = 0
var chargeTime = 0.8
var damage = 1
onready var animatedSprite = $AnimatedSprite
onready var shotSound = $YSort/ShotSoundOne

#func _ready():
#	particles.global_position = $Position2D.global_position

func _physics_process(delta):
	#print(animatedSprite.rotation_degrees)
	#BLASTER FOLLOW MOUSE:
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	animatedSprite.rotation_degrees = 360 - self.rotation_degrees
	#particles.rotation_degrees = 360 - self.rotation_degrees
	if(duration > chargeTime):
		animatedSprite.play("charged")
		$AnimatedSprite/Particles2D.emitting = true
		$AnimatedSprite/Light2D.enabled = true
		
		#condition for bigger charge
	else:
		$AnimatedSprite/Particles2D.emitting = false
		$AnimatedSprite/Light2D.enabled = false
		if (duration > (chargeTime * 0.6)):
			animatedSprite.play("charging")
		else:
			if(duration == 0):
				animatedSprite.play("empty")
			else:
				animatedSprite.play("default")
	#BLASTER FOLLOW CONTROLLER INPUT
	if Input.is_action_pressed("fire"):
		duration += delta
		
	var playerDirection = get_parent().get("direction")
	if (Input.is_action_just_released("fire")):
		#duration = 0
		if(bullet_instance and canFire and duration > chargeTime):
			shotSound.play()
			duration = 0
			var BulInt = bullet_instance.instance()
			#$YSort/ShotSoundOne.play()
			if(playerDirection.currentDirection == -1):
				BulInt.rotation_degrees =  180 - rotation_degrees
			else:
				BulInt.rotation =  rotation
			
			duration = 0
			BulInt.global_position = $Position2D.global_position
			BulInt.damage = damage
			get_parent().screenShaker._shake()
			get_parent().get_parent().add_child(BulInt)
			
			canFire = false
			
			yield(get_tree().create_timer(0.5), "timeout")
			canFire = true
		else:
			duration = 0			
	return
