extends CharacterBody2D
class_name MeleeEnemy

var player : Player
var othermelees : Array
var otherranged : Array
var all : Array
var type = "melee"
var hp : int = 3
@export var decaltoplace : PackedScene
var speed : float = 100.0  # Speed of the enemy
@export var player_distance : float = 200.0  # Minimum distance from the player
@export var separation_distance : float = 250.0  # Minimum distance from other melees
@export var repulsion_strength : float = 3.0  # Adjust this to control the 'springiness'
var active = false
@export var decalparentnoderef : Node

func setup(playerref, meleeref, rangedref, allref, typeofenemy, speedofenemy, decalspot):
	player = playerref
	othermelees = meleeref
	otherranged = rangedref
	all = allref
	type = typeofenemy
	speed = speedofenemy
	decalparentnoderef = decalspot
	active = true

func _process(_delta):
	look_at(player.position)
	# set the speed to be between 100 and 200 based on how close to 2 minutes the game is
	if not active:
		return
	velocity = Vector2.ZERO
	velocity += seek_player()  # Cohesion: Move towards the player
	velocity += avoid_others() * 1.5  # Separation: Avoid other melees, weighted more
	
	# Normalize and apply speed
	velocity = velocity.normalized() * speed
	move_and_slide()

func seek_player():
	# Cohesion towards the player
	return (player.position - position).normalized()

func avoid_others():
	var separation_vec = Vector2.ZERO
	var otherenemies
	if type == "melee":
		otherenemies = othermelees
	else:
		otherenemies = otherranged
	for other in otherenemies:
		if other == self:
			continue
		var dist = position.distance_to(other.position)
		if dist < separation_distance and dist > 0:  # Ensure dist is not zero to avoid division by zero
			# Calculate a springy repulsion force
			var repulsion_force = (separation_distance - dist) / separation_distance
			repulsion_force = pow(repulsion_force, repulsion_strength)  # Make the force more 'springy'
			separation_vec += (position - other.position).normalized() * repulsion_force
	
	# Enforce the player distance
	if position.distance_to(player.position) < player_distance:
		separation_vec += (position - player.position).normalized()
		
	
	return separation_vec

func damage():
	if not active:
		return
	hp -= 1
	if hp <= 0:
		# Paint the decal onto the ground
		# Make the decal a child of the Level/Decals/ node
		var decal = decaltoplace.instantiate()
		decal.position = position
		print("Rotation: ", position.angle_to(player.position))
		# get the dir vector between the player and the enemy
		var dir = player.global_position - global_position
		
		# Get a rotation off the X axis from this vector
		var angle = dir.angle()

		# Set the rotation of the decal to this angle + 180 degrees
		decal.rotation = angle + PI 
		decal.modulate = Color.from_hsv(randf(), 1, 1) 
		#reparent the decal to the level
		decalparentnoderef.add_child(decal)

		$CollisionShape2D.set_deferred("disabled", true)  # Disable collision
		#TODO: explode
		$Particles.emitting = true
		player.score += 100  # Assume player has a score property to increment
		$Explode.play()  # Play the explosion sound
		# Remove from scene
		$Sprite2D.visible = false
		othermelees.erase(self)
		active = false
		await get_tree().create_timer(2).timeout
		# Remove self from melee array
		queue_free()
