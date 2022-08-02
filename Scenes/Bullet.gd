extends Area2D

export var speed = 700
onready var rc = $RayCast2D
onready var sprite = $AnimatedSprite
onready var timer = $Timer
onready var ImpactSound = $ImpactSound
onready var travelParticles = $Particles2D
var damage

var hasHit = false

func _ready():
	$ShotSound.play()
	set_as_toplevel(true)
	sprite.play("move")

func _process(delta):
	#rc.set_debug_shape_custom_color = Color(0,0,0,1)
	#rc.debug_shape_thickness = 2.0
	if (rc.is_colliding() ):

		var hit = rc.get_collider().name
		var origin = rc.global_transform.origin
		var dot = rc.get_collision_point()
		var i = origin.distance_to(dot)
		
		if (i < 80):
			
			rc.force_raycast_update()
			origin = rc.global_transform.origin
			dot = rc.get_collision_point()
			i = origin.distance_to(dot)
			#position = dot
			position = lerp(position, dot, 0.5)
			
			if(i < 20):
				sprite.play("break")
				
				
				
				#timer.set_wait_time(0.2)
				#timer.set_one_shot(true)
				#timer.start()
				#yield(timer, "timeout")
				#print(timer.time_left)
				
				var t = Timer.new()
				t.set_wait_time(1.2)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
				$AnimatedSprite.visible = false
				var tr = Timer.new()
				tr.set_wait_time(3)
				tr.set_one_shot(true)
				self.add_child(tr)
				tr.start()
				yield(tr, "timeout")
				tr.queue_free()
				queue_free()
				

	else: 
		position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	


func _on_Area2D_body_entered(body):

		$ShotSound.playing = false
		if(!hasHit):
			ImpactSound.play()
			travelParticles.emitting = false
		if(("Enemy" in body.name or "object" in body.name or "Slime" in body.name) and hasHit == false):
			hasHit = true
			var playerDmg = self.get_parent().get_node("Player").projectileDamage
			
			var direction = Vector2(cos(self.rotation), sin(self.rotation))
			if body.has_method("destroy"):
				body.destroy(direction, playerDmg)
		else:
			hasHit = true

