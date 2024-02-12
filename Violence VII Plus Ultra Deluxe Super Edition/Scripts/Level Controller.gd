extends Node2D

var melee_enemies: Array = []
var ranged_enemies: Array = []
var enemies : Array = []

@export var player : Player
@export var melee_enemy : PackedScene
@export var ranged_enemy : PackedScene
@export var decalnode : Node
@onready var timer : Timer = $LevelTimer
var start_time


func _ready():
	start_time = Time.get_ticks_msec()
	timer.start()

# Spawn enemies in the map
# Enemies will spawn in random locations and the number of them according to the
# difficulty curve (a function of time and player's score(?))
func spawn_enemies():
	for i in range(0, 7):
		var enemy
		if randi_range(0, 10) > 3:
			enemy = melee_enemy.instantiate() as MeleeEnemy
			melee_enemies.append(enemy)
		else:
			enemy = ranged_enemy.instantiate() as MeleeEnemy
			ranged_enemies.append(enemy)
		enemies.append(enemy)
		var cur_time = Time.get_ticks_msec() - start_time
		# Start at 100, increase by approximately 50 per minute
		var speed_value = 100 + (cur_time / 60000.0) * 800
		speed_value = min(speed_value, 900.0) # cap at slightly slower than player
		enemy.setup(player, melee_enemies, ranged_enemies, enemies, "melee", speed_value, decalnode)
		# random location near the player
		# Don't spawn within 300 units of the player
		var enemyX = randf_range(player.position.x - 1000, player.position.x - 300) if randi() % 2 == 0 else randf_range(player.position.x + 300, player.position.x + 1000)
		var enemyY = randf_range(player.position.y - 1000, player.position.y - 300) if randi() % 2 == 0 else randf_range(player.position.y + 300, player.position.y + 1000)

		enemy.position = Vector2(enemyX, enemyY)
		add_child(enemy)
	# Determine how many enemies to spawn of each type

	# Spawn the enemies in random locations off screen
	# Determine the screen bounds from the camera's position and size
	# Pass in a reference to the enemy list to each enemy so they know of each 
	# other's existence
