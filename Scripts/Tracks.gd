extends Line2D

var timer = 0;

func _ready():
	set_as_toplevel(true);

func _process(delta):
	timer += delta;

	if (timer >= 0.1):
		var point = get_parent().global_position;
		add_point(point);
		timer = 0;

	if (points.size() > 100):
		remove_point(0);
