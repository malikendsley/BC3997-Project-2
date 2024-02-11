extends Control

@export var startScene = "res://Scenes/Level.tscn"

@onready var blip = $Blip1 as AudioStreamPlayer
@onready var blip2 = $Blip2 as AudioStreamPlayer
@export var textbox1 : Label
@export var textbox2 : Label

func _ready():
	textbox1.text = ""
	textbox2.text = ""
	# Wait 1 second
	await get_tree().create_timer(1).timeout

	# Play the blip sound
	blip.play()
	# Update the text 
	textbox1.text = "VIOLENCE"
	await get_tree().create_timer(.5).timeout
	blip.play()
	# Update the text 
	textbox1.text = "VIOLENCE VII "
	await get_tree().create_timer(.5).timeout
	blip.play()
	# Update the text 
	textbox1.text = "VIOLENCE VII PLUS "
	await get_tree().create_timer(.5).timeout
	blip.play()
	# Update the text 
	textbox1.text = "VIOLENCE VII PLUS ULTRA"
	await get_tree().create_timer(1.5).timeout

	blip2.play()
	textbox2.text = "DELUXE EDITION"


func gotonextscene():
	get_tree().change_scene(startScene)

func quit():
	get_tree().quit()
