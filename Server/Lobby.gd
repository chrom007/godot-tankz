extends Node

func _ready():
	print("Lobby");
	Network.server_start();
