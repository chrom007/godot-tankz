extends Node2D

func _ready():
	var childs = $Env.get_children();
	for child in childs:
		if child.is_in_group("tree"):
			randomize();
			var rot = rand_range(0, 360);
			child.rotate(rot);

	var room_size = $Background.rect_size;
	$Tank/Camera2D.limit_right = room_size.x;
	$Tank/Camera2D.limit_bottom = room_size.y;
