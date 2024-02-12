extends Line2D

var q : Array
@export var max_q : int

func _process(_delta):
    q.push_front(to_global(position))
    if q.size() > max_q:
        q.pop_back()

    clear_points()

    for point in q:
        add_point(point)