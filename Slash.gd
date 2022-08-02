extends Node2D



var hitting = false
var startedHit = false
onready var area = $Area2D
onready var timer = $Timer
onready var sprite = $Slash
var bodies = []
var localBody
var hitDamage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("slash") and !startedHit):
		startedHit = true
		sprite.play("hit")
		timer.set_wait_time(0.08)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")
		hitting = true
		sprite.play("charged")
		hitAll()
		area.set_collision_layer_bit(5,true)
		area.set_collision_layer_bit(6,true)
		area.set_collision_layer_bit(0,true)
		timer.set_wait_time(0.3)
		timer.set_one_shot(true)
		timer.start()
		yield(timer, "timeout")
		area.set_collision_layer_bit(0,false)
		area.set_collision_layer_bit(5,false)
		area.set_collision_layer_bit(6,false)
		sprite.play("default")
		hitting = false
		startedHit = false

func _on_Area2D_body_entered(body):
	if "slime" in body.name or "Slime" in body.name:
		if !bodies.has(body):
			bodies.append(body)
			if hitting == true:
				var mod = get_tree().get_root().get_node("World").get_node("Player")
				var rot = mod.getDirection()
				var rotation = get_parent().rotation
				#self.rotation
				if(rot == -1):
					rotation =  180 - rotation
				var direction = Vector2(cos(rotation), sin(rotation))
				body.destroy(direction,hitDamage)

func hitAll():
	if hitting == true:
		var mod = get_tree().get_root().get_node("World").get_node("Player")
		var rot = mod.getDirection()
		var rotation = get_parent().rotation
		if(rot == -1):
			rotation =  180 - rotation
		var direction = Vector2(cos(rotation), sin(rotation))
		for body in bodies:
			body.destroy(direction,hitDamage)
		bodies = []
		

func _on_Area2D_body_exited(body):
	if(bodies.has(body)):
		bodies.erase(body)
