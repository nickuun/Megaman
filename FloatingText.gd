extends Label


func show_value(size, value, travel, duration, spread, crit=null):
	text = value
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	rect_pivot_offset = rect_size / 2
	
	$Tween.interpolate_property(self, "rect_position",
	rect_position, rect_position + movement,duration,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	$Tween.interpolate_property(self, "modulate:a",
	1.0, 0.0, duration,Tween.TRANS_LINEAR,
	Tween.EASE_IN_OUT)
	
	if crit!= null:
		#modulate = Color(0.52, 0.82, 0.21)
		self.set("custom_colors/font_color", Color(crit))
		$Tween.interpolate_property(self, "rect_scale",
		rect_scale*2, rect_scale,
		0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	
	self.get("custom_fonts/font").set_size(size)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
