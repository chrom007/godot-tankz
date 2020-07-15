extends Node

func _ready():
	print("Lobby");
	Network.server_start();
	get_tree().change_scene("res://Scenes/World.tscn");
