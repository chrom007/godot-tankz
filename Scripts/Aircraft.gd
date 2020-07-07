extends Node2D

const SPEED = 10;
var velocity := Vector2.RIGHT;

func _ready():
	randomize();
	var angle = rand_range(0, 360);
	velocity = velocity.rotated(angle);
	rotate(angle);


func _process(delta):
	position += velocity * delta * SPEED * 10;
