extends Node2D

var player : Player # ref

var fired = false
var direction
var speed
@export var scorch : PackedScene
@export var explosion : PackedScene

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
		var s = scorch.instantiate()
		var e = explosion.instantiate()
		s.position = body.global_position
		e.position = body.global_position
		get_tree().get_root().get_node("Node2D/Level/Decals").add_child(s)
		get_tree().get_root().get_node("Node2D/Level/Decals").add_child(e)
		# Detonate the bullet
		var nodes = $BombArea.get_overlapping_bodies()
		for node in nodes:
			if node is MeleeEnemy:
				node.die()
		queue_free()
