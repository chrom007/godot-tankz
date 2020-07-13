extends Node2D

func _ready():
	print("World");
	randomize();
	var childs = $Env.get_children();
	for child in childs:
		### Randomize TREEs
		if (child.is_in_group("tree")):
			var rot = rand_range(0, 360);
			child.rotate(rot);

		### Colorize HOMEs
		if (child.is_in_group("home")):
			var rand_r = rand_range(70, 200);
			var rand_g = rand_range(70, 200);
			var rand_b = rand_range(70, 200);
			var color : Color = Color(0, 0, 0, 1);
			color.r8 = rand_r;
			color.g8 = rand_g;
			color.b8 = rand_b;
			child.find_node("Sprite").modulate = color;

	### Camera limits
	var room_size = $Background.rect_size;
	$Tank/Camera2D.limit_right = room_size.x;
	$Tank/Camera2D.limit_bottom = room_size.y;
