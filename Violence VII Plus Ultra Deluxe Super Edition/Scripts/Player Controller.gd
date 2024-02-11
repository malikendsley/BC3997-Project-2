extends CharacterBody2D
class_name Player
@export var enabled = true
@export var move_speed = 1000
@export var bullet : PackedScene
var can_fire = true
var firing = false
var score = 0

@export var initial_fire_rate : int

@onready var fire_timer: Timer = $FireTimer

@export var scoretext : Label

func _ready():
	fire_timer.wait_time = 1.0 / initial_fire_rate

func _input(event):
	if event.is_action_pressed("Fire"):
		firing = true
	if event.is_action_released("Fire"):
		firing = false
		


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
	
	# add the node to the scene under the Gameplay node
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = global_position
	# get vector between player and mouse
	var dir = get_global_mouse_position() - global_position

	bullet_instance.fire(dir.normalized(), 1000, self)
	print("Fire")
	fire_timer.start()

func _on_fire_timer_timeout():
	can_fire = true
 
