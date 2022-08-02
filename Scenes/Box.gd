extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var motion = Vector2(0,0)
const gravityOverride = 1.2
var collidingBodies
# Called when the node enters the scene tree for the first time.
func _ready():
	self.gravity_scale = gravityOverride
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func destroy(direction,damage):
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	self.queue_free()

