extends CharacterBody2D
class_name Player
@export var enabled = true
@export var move_speed = 1000
@export var bullet : PackedScene
@export var big_bullet : PackedScene
@export var bomb_ui : Control
@export var losescene = "res://Scenes/Lose.tscn"

var can_fire = true
var can_space_fire = true
var firing = false
var score = 0
var disp = 0
var lose_time = 2.0
var disp_threshhold = 400
var lose_ticks = 0 # At this time, the player will lose. Reset after displacing enough
var kills = 0
var bombs = 1

@onready var shoot_sound = $Shoot
@onready var big_shoot_sound = $BigShoot
@onready var reload_sound = $Reload
@export var initial_fire_rate : int

@onready var fire_timer: Timer = $FireTimer
@onready var fire_space_timer: Timer = $FireSpaceTimer
@export var scoretext : Label
@export var progressbar : ProgressBar

func _ready():
	fire_timer.wait_time = 1.0 / initial_fire_rate
	disp = 0
	last_pos = global_position
	lose_ticks = Time.get_ticks_msec() + lose_time * 1000 * 5
	Events.connect("enemy_died", enemykilled)
	
func _input(event):
	if event.is_action_pressed("Fire"):
		firing = true
	if event.is_action_released("Fire"):
		firing = false
	if event.is_action_pressed("Space"):
		space_fire()

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
		lose_ticks = Time.get_ticks_msec() + lose_time * 1000

	if Time.get_ticks_msec() > lose_ticks:
		lose()

	if bombs > 0 and can_space_fire:
		bomb_ui.visible = true
	else:
		bomb_ui.visible = false

	scoretext.text = "Violence: " + str(score)
	# Show the proportion between the time left and the time to lose, draining the bar accordingly
	
	progressbar.value = (lose_ticks - Time.get_ticks_msec()) / (lose_time * 1000) * 100
	# If the bar is above 80%, set to 100
	if progressbar.value > 80:
		progressbar.value = 100
		# If the bar is below 20%, set to 0
	# Modulate the progress bar towards red as the time runs out
	progressbar.modulate = Color(1, (lose_ticks - Time.get_ticks_msec()) / (lose_time * 1000), (lose_ticks - Time.get_ticks_msec()) / (lose_time * 1000))

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

func _on_FireSpaceTimer_timeout():
	can_space_fire = true

func space_fire():
	if not can_space_fire or bombs == 0:
		return
	can_space_fire = false
	if not enabled:
		return
	bombs -= 1
	fire_space_timer.start()
	# instantiate an instance of the bullet scene
	# fire it towards the mouse cursor
	var bullet_instance = big_bullet.instantiate()
	big_shoot_sound.play()
	# add the node to the scene under the Gameplay node
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = global_position
	# get vector between player and mouse
	var dir = get_global_mouse_position() - global_position

	bullet_instance.fire(dir.normalized(), 1000, self)
	# Fire a bigger bullet
func lose(): 
	Events.finalscore = score
	get_tree().change_scene_to_file(losescene)

func enemykilled():
	score += 100
	kills +=1
	if kills % 10 == 0:
		reload_sound.play() 
		bombs = 1
