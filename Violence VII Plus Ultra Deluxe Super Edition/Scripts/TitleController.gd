extends Control

@export var startScene = "res://Scenes/Level.tscn"

@onready var blip = $Blip1 as AudioStreamPlayer
@onready var blip2 = $Blip2 as AudioStreamPlayer
@onready var blip3 = $Blip3 as AudioStreamPlayer
@export var textbox1 : Label
@export var textbox2 : Label
@export var textbox3 : Label

func _ready():
    textbox1.text = ""
    textbox2.text = ""
    textbox3.text = ""
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
    textbox2.text = "DELUXE"

    await get_tree().create_timer(1.5).timeout
    blip3.play()
    textbox3.text = "GOTY EDITION"

func gotonextscene():
    blip.play()
    get_tree().change_scene_to_file(startScene)

func quit():
    get_tree().quit()
