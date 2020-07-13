extends Node

func _ready():
	var args = OS.get_cmdline_args();
	var is_server = true if (args.size() > 0 && args[0].match("--server")) else false;

	if (is_server):
		print("SERVER detected");
		get_tree().change_scene("res://Server/Lobby.tscn");
