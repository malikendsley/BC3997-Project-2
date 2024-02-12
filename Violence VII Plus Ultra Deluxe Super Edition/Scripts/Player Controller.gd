extends CharacterBody2D
class_name Player
@export var enabled = true
@export var move_speed = 1000
@export var bullet : PackedScene
var can_fire = true
var firing = false
var score = 0
var disp = 0
# If the player doesn't cross this threshold at least once every 1 second, they will lose
var lose_time = 2.0
var disp_threshhold = 200

@onready var lose_timer = $LoseTimer as Timer

@onready var shoot_sound = $Shoot

@export var initial_fire_rate : int

@onready var fire_timer: Timer = $FireTimer

@export var scoretext : Label

func _ready():
	fire_timer.wait_time = 1.0 / initial_fire_rate
	disp = 0
	last_pos = global_position
	lose_timer.wait_time = 5.0 # Be more generous at game start
	lose_timer.start()
func _input(event):
	if event.is_action_pressed("Fire"):
		firing = true
	if event.is_action_released("Fire"):
		firing = false
		

var last_pos = Vector2()

func _process(_delta):
	if not enabled:
		return

	# face the mouse cursor
	look_at(get_global_mouse_position())

	# move the player
	var move_dir = Vector2()
	if Input.is_action_pressed("Left"):
		move_dir.x -= 1
	if Input.is_action_pressed("Right"):
		move_dir.x += 1
	if Input.is_action_pressed("Up"):
		move_dir.y -= 1
	if Input.is_action_pressed("Down"):
		move_dir.y += 1
	velocity = move_dir.normalized() * move_speed

	if firing: 
		fire()
	move_and_slide()

	# Handle disp
	disp += (global_position - last_pos).length()
	last_pos = global_position

	if disp > disp_threshhold:
		disp = 0
		# Reset the lose timer
		lose_timer.stop()
		lose_timer.wait_time = lose_time
		lose_timer.start()
	scoretext.text = "Violence: " + str(score)



func fire():
	if not can_fire:
		return
	can_fire = false
	if not enabled:
		return

	# instantiate an instance of the bullet scene
	# fire it towards the mouse cursor
	var bullet_instance = bullet.instantiate()
	shoot_sound.play()
	# add the node to the scene under the Gameplay node
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = global_position
	# get vector between player and mouse
	var dir = get_global_mouse_position() - global_position

	bullet_instance.fire(dir.normalized(), 1000, self)
	fire_timer.start()

func _on_fire_timer_timeout():
	can_fire = true

func _on_lose_timer_trigger(): 
	print("You lose!")
