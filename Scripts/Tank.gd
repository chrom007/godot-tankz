extends KinematicBody2D

const HEAD_SPEED = 3;
const ROT_SPEED = 2.5;
const MOVE_SPEED = 5;

var velocity := Vector2.ZERO;

func _process(delta):
	moving(delta);

func moving(delta):
	var velocity := Vector2.ZERO;

	if (Input.is_action_pressed("body_left")):
		rotate(-ROT_SPEED * delta);

	if (Input.is_action_pressed("body_right")):
		rotate(ROT_SPEED * delta);

	if (Input.is_action_pressed("body_forward")):
		velocity.x = 1;

	if (Input.is_action_pressed("body_back")):
		velocity.x = -1;

	if (Input.is_action_pressed("head_left")):
		$Head.rotate(-HEAD_SPEED * delta);

	if (Input.is_action_pressed("head_right")):
		$Head.rotate(HEAD_SPEED * delta);

	if (velocity.x == 0):
		$AnimatedSprite.play("idle");
	else:
		$AnimatedSprite.play("moving");

	#velocity.rotated()
	velocity = velocity.normalized() * MOVE_SPEED * delta * 1000;
	velocity = velocity.rotated(rotation);
	move_and_slide(velocity, Vector2.ZERO);
