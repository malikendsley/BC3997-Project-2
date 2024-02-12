extends Control

@export var startScene = "res://Scenes/Level.tscn"

@export var scorelabel : Control 

func _ready():
	scorelabel.text = "\nFINAL VIOLENCE: " + str(Events.finalscore)

func quit():
	get_tree().quit()
	
func cont():
	get_tree().change_scene_to_file(startScene)
