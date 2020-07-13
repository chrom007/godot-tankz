extends Node


func _ready():
	pass;


func _on_Single_pressed():
	get_tree().change_scene("res://Scenes/World.tscn");


func _on_Multiplayer_pressed():
	$Single.disabled = true;
	$Multiplayer.disabled = true;
	$Status.text = "Finding server...";
	Network.client_start();
