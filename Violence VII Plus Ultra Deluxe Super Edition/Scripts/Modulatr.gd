extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    # Modulate this object's color to be rainbow
    var hue = int(Time.get_ticks_msec() / 3.0 ) % 360
    modulate = Color.from_hsv(hue / 360.0, 1, 1) 