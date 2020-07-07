extends Node2D

func start(_position, _scale):
	position = _position;
	$Particles2D.scale = Vector2(_scale, _scale);
	$Particles2D.one_shot = true;
	$Particles2D.emitting = true;

func _on_Timer_timeout():
	queue_free();
