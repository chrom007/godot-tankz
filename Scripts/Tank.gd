extends KinematicBody2D

const HEAD_SPEED = 3;
const ROT_SPEED = 2;
const MOVE_SPEED = 6;
const SHOT_DELAY = 1;
const ROAD_BOOST = 1.75;

var shoot_ready = true;
var velocity := Vector2.ZERO;
var BOOST = 1;

var tilemap : TileMap = null;

func _ready():
	tilemap = get_parent().get_node("TileMap");

func _process(delta):
	moving(delta);
	shooting();
	boosting();

func shooting():
	if (Input.is_action_just_pressed("shoot") && shoot_ready):
		var Bullet = preload("res://Objects/Bullet.tscn");
		var bullet = Bullet.instance();
		var position = $Head/Muzzle.global_position;
		var direction = $Head.global_rotation;
		bullet.create(position, direction);
		get_tree().get_root().add_child(bullet);

		shoot_ready = false;
		$ShootTimer.start(SHOT_DELAY);

func moving(delta):
	velocity = Vector2.ZERO;

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

	if (velocity.x == 0 && $Anim.animation != "idle"):
		$Anim.play("idle");

	if (velocity.x != 0 && $Anim.animation != "moving"):
		$Anim.play("moving");

	#velocity.rotated()
	velocity = (velocity * MOVE_SPEED * delta * 1000 * BOOST).rotated(rotation);
	move_and_slide(velocity, Vector2.ZERO);

func boosting():
	var pos := tilemap.world_to_map(global_position);
	var cell := tilemap.get_cellv(pos);
	if (cell == 0):
		BOOST = ROAD_BOOST;
	else:
		BOOST = 1;

func _on_ShootTimer_timeout():
	shoot_ready = true;
