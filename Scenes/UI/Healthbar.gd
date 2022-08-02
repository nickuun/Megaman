extends CanvasLayer

var prevHearts = 0
var hearts = 0 setget setHearts
var maxHearts = 4 setget setMaxHeart
const heartSpriteSize = 120 #pixels wide (x)
var heartBreak = preload("res://Scenes/UI/AnimatedHeart.tscn")

onready var heartsUIFull = $HeartsUIFull
onready var heartsUIEmoty = $HeartsUIEmpty
onready var firstHeart = $Position2D

func setHearts(value):
	prevHearts = hearts
	hearts = clamp(value, 0 , maxHearts)
	
	if((prevHearts - hearts)< 0 and (hearts>0)):
		var counter = 0
		for i in -1*((prevHearts - hearts) ):
			var animatedHeart = heartBreak.instance()
			animatedHeart.position.x = firstHeart.position.x + ((prevHearts + counter) * heartSpriteSize)
			animatedHeart.position.y = firstHeart.position.y
			self.add_child(animatedHeart)
			counter +=1
	else:
		var counter = 0
		for i in (prevHearts - hearts):
			var animatedHeart = heartBreak.instance()
			animatedHeart.position.x = firstHeart.position.x + ((hearts + counter) * heartSpriteSize)
			animatedHeart.position.y = firstHeart.position.y
			self.add_child(animatedHeart)
			counter -= 1
	
	if heartsUIFull!=null:
		heartsUIFull.rect_size.x = hearts * heartSpriteSize
	
func setMaxHeart(value):
	maxHearts = max(value, 1)
	if heartsUIEmoty != null:
		heartsUIEmoty.rect_size.x = maxHearts * heartSpriteSize


func _ready():
	var player = self.get_parent().get_node("Player")
	self.maxHearts = player.maxHealth
	self.hearts = player.health
	player.connect("healthChanged", self,"setHearts")

#func _physics_process(delta):
	#print(self.hearts)
	


	

