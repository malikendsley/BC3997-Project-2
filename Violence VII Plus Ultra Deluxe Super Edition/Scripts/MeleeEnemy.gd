extends CharacterBody2D
class_name MeleeEnemy

var player : Player
var othermelees : Array
var hp : int = 3
var speed : float = 100.0  # Speed of the enemy
var separation_distance : float = 250.0  # Minimum distance from other melees
var repulsion_strength : float = 3.0  # Adjust this to control the 'springiness'
var active = false

func setup(playerref, othermeleesref):
	player = playerref
	othermelees = othermeleesref
	active = true

func _process(_delta):
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
	for other in othermelees:
		if other == self:
			continue
		var dist = position.distance_to(other.position)
		if dist < separation_distance and dist > 0:  # Ensure dist is not zero to avoid division by zero
			# Calculate a springy repulsion force
			var repulsion_force = (separation_distance - dist) / separation_distance
			repulsion_force = pow(repulsion_force, repulsion_strength)  # Make the force more 'springy'
			separation_vec += (position - other.position).normalized() * repulsion_force
	return separation_vec

func damage():
	if not active:
		return
	hp -= 1
	if hp <= 0:
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
