extends Node2D

var melee_enemies: Array = []
var ranged_enemies: Array = []

@export var player : Player
@export var melee_enemy : PackedScene
@export var ranged_enemy : PackedScene

@onready var timer : Timer = $LevelTimer

func _ready():
	pass
	# Put the player in the map

	# Start the spawn timer


# Spawn enemies in the map
# Enemies will spawn in random locations and the number of them according to the
# difficulty curve (a function of time and player's score(?))
func spawn_enemies():
	for i in range(0, 1):
		var enemy = melee_enemy.instantiate() as MeleeEnemy
		melee_enemies.append(enemy)

		enemy.setup(player, melee_enemies)
		# random location near the player
		enemy.position = Vector2(randf_range(player.position.x - 1000, player.position.x + 1000), randf_range(player.position.y - 1000, player.position.y + 1000))
		add_child(enemy)
	# Determine how many enemies to spawn of each type

	# Spawn the enemies in random locations off screen
	# Determine the screen bounds from the camera's position and size
	# Pass in a reference to the enemy list to each enemy so they know of each 
	# other's existence
