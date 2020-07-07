extends Area2D

const SPEED = 300;

var velocity = Vector2.ZERO;

func create(_position, _direction):
	position = _position;
	rotation = _direction;
	velocity = Vector2(1, 0).rotated(_direction).normalized();
	$Particles2D.speed_scale = 7.5;
	yield(get_tree().create_timer(0.1), "timeout");
	$Particles2D.speed_scale = 2.5;

func _physics_process(delta):
	position += velocity * delta * SPEED;

func destroy():
	var Explosive = preload("res://Objects/Explosive.tscn");
	var explosive = Explosive.instance();
	explosive.start(position, 4);
	get_tree().get_root().add_child(explosive);
	queue_free();

func _on_Timer_timeout():
	destroy();

func _on_Bullet_body_entered(body : Node2D):
	if (body.is_in_group("static")):
		destroy();
