extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxSpeed = 10
var motion = Vector2.ZERO
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = self.get_parent().get_node("Player")
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(player != null):
		self.global_position = player.global_position
	move_and_slide ( Vector2.ZERO,Vector2( 0, -1 ),false, 4,0.785398,true )
