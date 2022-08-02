extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hasCollected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FlatDamageBook_body_entered(body):
	if (("Player" in body.name) and (!hasCollected)) :
		hasCollected = true
		body.coinValue = body.coinValue + 1
		var colour = Color( 1, 0.5, 0.31, 1)
		$FCTManager.show_value(8,"+1 Projectile Damage", colour)
		$Particles2D.emitting = false
		var t = Timer.new()
		t.set_wait_time(0.3)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		$AnimatedSprite.play("blank")
		t.set_wait_time(0.8)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		self.queue_free()
