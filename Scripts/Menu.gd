extends Node


func _ready():
	Network.connect("connection_failed", self, "connection_failed");
	$Single.connect("pressed", self, "_on_Single_pressed");
	$Multiplayer.connect("pressed", self, "_on_Multiplayer_pressed");


func _on_Single_pressed():
	get_tree().change_scene("res://Scenes/World.tscn");


func _on_Multiplayer_pressed():
	$Single.disabled = true;
	$Multiplayer.disabled = true;
	$Status.text = "Finding server...";
	var ip = $IP.text;
	Network.client_start(ip);

func connection_failed():
	$Status.text = "Connection failed!";
	$Single.disabled = false;
	$Multiplayer.disabled = false;

#	var qwe = preload("res://Scenes/World.tscn").instance();
#	get_tree().get_root().add_child(qwe);
#	get_tree().change_scene("res://Scenes/World.tscn");
