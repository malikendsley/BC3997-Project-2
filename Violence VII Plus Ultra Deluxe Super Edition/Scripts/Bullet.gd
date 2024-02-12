extends Node2D

class_name Bullet

var player : Player # ref

var fired = false
var direction
var speed


func fire(dir, spd, playerref):
	fired = true
	player = playerref
	self.direction = dir
	self.speed = spd

func _process(delta):
	if fired:

		position += direction * speed * delta
		# If get more than 1000 pixels away from the player, destroy the bullet
		if position.distance_to(player.position) > 5000:
			queue_free()
			



func _on_area_2d_body_entered(body:Node2D):
	if body is MeleeEnemy:
		body.damage()
		if $Impact:
			$Impact.play()
		var sound = $Impact
		remove_child(sound)
		var particles = $Particles
		remove_child(particles)
		get_parent().add_child(particles)
		get_parent().add_child(sound)
		if particles:
			particles.set_deferred("emitting", false)
		queue_free()
