extends Camera2D

@onready var player = get_node("../")


func _process(_delta):
    # Offset the camera to place it between the player and the mouse
    # 2D, so we don't need to worry about depth
    offset = (player.global_position - get_global_mouse_position()) / 50
    offset.x = clamp(-offset.x, -50, 50)
    offset.y = clamp(-offset.y, -50, 50)
