extends Node2D

var Tank = preload("res://Objects/Tank.tscn");

func _ready():
	print("World");
	scene_setup();

	set_network_master(1, true);

	if (!Network.online):
		spawn_new_player(0, "Player");


	Network.connect("player_joined", self, "spawn_new_player");
	spawn_players();

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://Scenes/Menu.tscn");
		Network.leave();

func spawn_players():
	for pid in Network.players:
		spawn_new_player(pid, Network.players[pid]);

func spawn_new_player(id, name):
	var tank = Tank.instance();
	tank.set_network_master(id);
	tank.name = str(id);
	tank.username = name;
	get_node("/root/World").add_child(tank);
	if (id == get_tree().get_network_unique_id() && !Network.is_server):
		tank.position = tank.t_pos;
		tank.rotation_degrees = tank.t_rot;
		camera_setup(id);
	else:
		tank.get_node("Camera").queue_free();
		tank.position = Vector2(-100, -100);

func scene_setup():
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
			var shadow : Sprite = child.get_node("Shadow");
			shadow.global_position += Vector2(8, 8);
			child.get_node("Sprite").modulate = color;

### Camera limits
func camera_setup(id):
	var room_size = $Background.rect_size;
	var tank = get_node(str(id));
	var camera = tank.get_node("Camera");
	camera.limit_right = room_size.x;
	camera.limit_bottom = room_size.y;
