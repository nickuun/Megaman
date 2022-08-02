extends Particles2D

func splat():
	if randi() % 2:
		self.rotation_degrees = self.rotation_degrees + 180
	self.emitting = true

