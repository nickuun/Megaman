extends CanvasLayer

onready var label = $Label
var coins = 0

func _ready():
	var player = self.get_parent().get_node("Player")
	self.coins = player.coins
	player.connect("coinsChanged", self,"setCoins")
	label.text = String(coins)

func setCoins(value):
	coins = value
	label.text = String(coins)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
