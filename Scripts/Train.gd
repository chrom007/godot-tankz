extends StaticBody2D

const SPEED = 100;
onready var follow : PathFollow2D = get_parent();

func _physics_process(delta):
	follow.offset += SPEED * delta;
