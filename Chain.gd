"""
This script controls the chain.
"""
extends Node2D

onready var links = $Links		# A slightly easier reference to the links
onready var tipCol = $Tip
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.
const SPEED = 15	# The speed with which the chain moves
var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall
var playerPos
var returning = false
var returnVel = 0
var returned = true
var returnSpeedMod = enemyReturnSpeed
var enemyInitialReturnSpeed = 20
var enemyReturnSpeed = 2
var defaultReturnSpeed = 1
var enemyGrabbed = false
var grabbedEnemy 
var grabDelay = 0
var grabDelayTime = 5
var canGrab = true

func releaseEnemy():
	enemyGrabbed = false
	grabbedEnemy.hooked = false
	grabbedEnemy = null
	returnSpeedMod = defaultReturnSpeed
	
# shoot() shoots the chain in a given direction
func shoot(dir: Vector2) -> void:
	canGrab = true
	returnSpeedMod = defaultReturnSpeed
	returned = false
	returning = false
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip = self.global_position		# reset the tip position to the player's position
	tipCol.set_collision_layer_bit(0,true)
	tipCol.set_collision_mask_bit(2,true)
# release() the chain
func release() -> void:
	#TESTING START
	returnVel = 0
	returning = true
#	enemyGrabbed = false
#	grabbedEnemy = null
	
	#TESTING END
	flying = false	# Not flying anymore	

	hooked = false	# Not attached anymore
	tipCol.set_collision_layer_bit(0,false)
	tipCol.set_collision_mask_bit(2,false)


# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	grabDelay += _delta
#	self.visible = flying or hooked	# Only visible if flying or attached to something
#	if not self.visible:
#		return	# Not visible -> nothing to draw

	self.visible = !returned
	if not self.visible:
		enemyGrabbed = false
		grabbedEnemy = null
		return	# Not visible -> nothing to draw
	if enemyGrabbed and !returning:
		release()

	var tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	returnVel += _delta * 2
	if enemyGrabbed and (grabbedEnemy != null) :
		if grabbedEnemy.has_method("pull"):
			grabbedEnemy.pull(tipCol.global_position)
	if  !returned:
		$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
		if flying:
			# `if move_and_collide()` always moves, but returns true if we did collide
			if $Tip.move_and_collide(direction * SPEED):
				hooked = true	# Got something!
				flying = false	# Not flying anymore
		#tip = $Tip.global_position	# set `tip` as starting position for next frame
	if returning:
		playerPos = self.get_parent().position()
		
		tipCol.global_position = lerp(tipCol.global_position, playerPos, (returnVel/returnSpeedMod))
		var distance = pow(playerPos.x - tipCol.global_position.x,2) + pow(playerPos.y - tipCol.global_position.y,2);
		if distance < 650:
			if grabbedEnemy != null:
				grabbedEnemy.hooked = false
			returning = false
			returned = true
	tip = $Tip.global_position	# set `tip` as starting position for next frame	

func _on_Area2D_body_entered(body):
	if body.has_method("pull") and !returned and canGrab:
		grabDelay = 0
		canGrab = false
		enemyGrabbed = true
		grabbedEnemy = body
		returnSpeedMod = enemyInitialReturnSpeed
#		var t = Timer.new()
#		t.set_wait_time(1)
#		t.set_one_shot(true)
#		self.add_child(t)
#		t.start()
#		yield(t, "timeout")
#		t.queue_free()
#		returnSpeedMod = enemyReturnSpeed
#		body.pull()
#		body.position = tipCol.global_position
