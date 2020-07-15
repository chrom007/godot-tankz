extends Node


func _ready():
	pass;


func _on_Single_pressed():
	get_tree().change_scene("res://Scenes/World.tscn");


func _on_Multiplayer_pressed():
	$Single.disabled = true;
	$Multiplayer.disabled = true;
	$Status.text = "Finding server...";
	var ip = $IP.text;
	Network.client_start(ip);

#	var qwe = preload("res://Scenes/World.tscn").instance();
#	get_tree().get_root().add_child(qwe);
#	get_tree().change_scene("res://Scenes/World.tscn");
