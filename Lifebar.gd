extends Node2D
var isVis = false

var bar_green = preload("res://barHorizontal_green.png")
var bar_red = preload("res://barHorizontal_red.png")
var bar_yellow = preload("res://barHorizontal_yellow.png")

onready var healthbar = $HealthBar

func _ready():
	hide()
	if get_parent() and get_parent().get("max_health"):
		healthbar.max_value = get_parent().max_health
		if isVis:
			show()
		
func _process(delta):
	global_rotation = 0
	
func update_healthbar(value):
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if value < healthbar.max_value:
		if isVis:
			show()
	healthbar.value = value


func _on_Area2D_body_entered(body):
	if "Player" in body.name and !isVis:
		isVis = true
		self.visible = true
