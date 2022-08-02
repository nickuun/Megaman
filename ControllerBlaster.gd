extends AnimatedSprite

var canFire = true
var bullet_instance = preload("res://Scenes/Bullet.tscn")

func _physics_process(delta):
	#BLASTER FOLLOW MOUSE:
	var mousePos = get_global_mouse_position()
	#look_at(mousePos)
	
	#BLASTER FOLLOW CONTROLLER INPUT
	var playerDirection = get_parent().get("direction")
	var controllerangle = Vector2.ZERO
	var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_2)
	var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_3)
	controllerangle = Vector2(xAxisRL, yAxisUD).angle()
	rotation = controllerangle
	if(playerDirection.currentDirection == -1):
		self.rotation_degrees = 180 - rotation_degrees
	
	if (Input.is_action_just_released("controller_fire") and canFire):
		if(bullet_instance):
			var BulInt = bullet_instance.instance()
			if(playerDirection.currentDirection == -1):
				BulInt.rotation_degrees =  180 - rotation_degrees
			else:
				BulInt.rotation =  rotation
			
			BulInt.global_position = $Position2D.global_position
			get_parent().screenShaker._shake()
			get_parent().get_parent().add_child(BulInt)
			canFire = false
			yield(get_tree().create_timer(0.5), "timeout")
			canFire = true
						
	return
