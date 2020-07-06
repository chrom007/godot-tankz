extends Area2D

const SPEED = 300;

var velocity = Vector2.ZERO;

func create(_position, _direction):
	position = _position;
	rotation = _direction;
	velocity = Vector2(1, 0).rotated(_direction).normalized();
	$Particles2D.speed_scale = 7.5;

func _ready():
	yield(get_tree().create_timer(0.1), "timeout");
	$Particles2D.speed_scale = 2.5;

func _physics_process(delta):
	position += velocity * delta * SPEED;


func _on_Timer_timeout():
	queue_free();
