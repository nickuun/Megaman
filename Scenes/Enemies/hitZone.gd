extends Area2D

var enemy

func _ready():
	enemy = self.get_parent()

func _on_hitZone_body_entered(body):
	var player = body

	if "Player" in body.name and self.get_parent().alive:
		if body.global_position.x < self.global_position.x:
			body.hit(-1)
		else:
			body.hit(1)
		enemy.attack()
		
