extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var options = ["Lifetime", "Blood","Tuft", "FlowerOne", "flowerTwo","tuftTwo","mushroomTwo","mushroomThree","flowerThree","flowerFour","acorn"]
var optionss =["acorn", "tuftTwo"]
var exception = "acorn"
var choice
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.global_rotation_degrees = 0
	self.rotation_degrees = 0
	rng.randomize()
	var my_random_number = rng.randf_range(0, len(options))
	$AnimationPlayer.play(options[my_random_number])
	choice = options[my_random_number]
#	$AnimationPlayer.play("Lifetime")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.global_rotation_degrees != 0 or self.rotation_degrees != 0) and (choice != exception):
		self.global_rotation_degrees = 0
		self.rotation_degrees = 0
