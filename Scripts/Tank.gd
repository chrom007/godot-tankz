extends KinematicBody2D

const HEAD_SPEED = 3;
const ROT_SPEED = 2;
const MOVE_SPEED = 7;
const SHOT_DELAY = 1;
const ROAD_BOOST = 1.85;

var shoot_ready = true;
var velocity := Vector2.ZERO;
var BOOST = 1;
var username = "USER";

var background : TextureRect = null;
var tilemap : TileMap = null;

puppet var t_pos = Vector2(235, 90);
puppet var t_rot = 90;
puppet var h_rot = 0;

func _ready():
	tilemap = get_parent().get_node("Env/Roads");
	background = get_parent().get_node("Background");
	$Nick.text = username;

func _physics_process(delta):
	if is_network_master():
		moving(delta);
		shooting();
		boosting();
		wrapping();

		# puppet_position = position;
		if (velocity != Vector2.ZERO):
			t_pos = position;
			rset_unreliable("t_pos", t_pos);
		if (t_rot != rotation_degrees):
			t_rot = rotation_degrees;
			rset_unreliable("t_rot", t_rot);
		if (h_rot != $Head.rotation_degrees):
			h_rot = $Head.rotation_degrees;
			rset_unreliable("h_rot", h_rot);
	else:
		position = t_pos;
		rotation_degrees = t_rot;
		$Head.rotation_degrees = h_rot;


func shooting():
	if (Input.is_action_just_pressed("shoot") && shoot_ready && is_network_master()):
		if (Network.online):
			rpc("shoot");
		else:
			shoot();

puppetsync func shoot():
	var Bullet = preload("res://Objects/Bullet.tscn");
	var bullet = Bullet.instance();
	var position = $Head/Muzzle.global_position;
	var direction = $Head.global_rotation;
	get_tree().get_root().add_child(bullet);
	bullet.create(position, direction);

	shoot_ready = false;
	$ShootTimer.start(SHOT_DELAY);
	$HeadAnim.play("shoot", -1, 7);


func moving(delta):
	velocity = Vector2.ZERO;

	if (Input.is_action_pressed("body_forward")):
		velocity.x = 1;

	if (Input.is_action_pressed("body_back")):
		velocity.x = -0.5;

	if (Input.is_action_pressed("body_left")):
		var md = 1 if velocity.x >= 0 else -1;
		rotate(-ROT_SPEED * delta * md);
#		$Head.rotate(ROT_SPEED * delta * md);

	if (Input.is_action_pressed("body_right")):
		var md = 1 if velocity.x >= 0 else -1;
		rotate(ROT_SPEED * delta * md);
#		$Head.rotate(-ROT_SPEED * delta * md);

	if (Input.is_action_pressed("head_left")):
		$Head.rotate(-HEAD_SPEED * delta);

	if (Input.is_action_pressed("head_right")):
		$Head.rotate(HEAD_SPEED * delta);

	if (velocity.x == 0):
		if ($BodyAnim.animation != "idle"):
			$BodyAnim.play("idle");

	if (velocity.x != 0):
		if ($BodyAnim.animation != "moving"):
			$BodyAnim.play("moving");

	#velocity.rotated()
	velocity = (velocity * MOVE_SPEED * delta * 500 * BOOST).rotated(rotation);
	move_and_slide(velocity, Vector2.ZERO);


func wrapping():
	var pos := tilemap.world_to_map(global_position);
	var cell := tilemap.get_cellv(pos);

	if (cell == 0):
		if (transform.origin.x > background.rect_size.x + 20):
			transform.origin.x = -20;
		if (transform.origin.y > background.rect_size.y + 20):
			transform.origin.y = -20;
		if (transform.origin.x < -20):
			transform.origin.x = background.rect_size.x + 20;
		if (transform.origin.y < -20):
			transform.origin.y = background.rect_size.y + 20;
	else:
		if (transform.origin.x > background.rect_size.x):
			transform.origin.x = background.rect_size.x;
		if (transform.origin.y > background.rect_size.y):
			transform.origin.y = background.rect_size.y;
		if (transform.origin.x < 0):
			transform.origin.x = 0;
		if (transform.origin.y < 0):
			transform.origin.y = 0;


func boosting():
	var pos := tilemap.world_to_map(global_position);
	var cell := tilemap.get_cellv(pos);
	if (cell == 0):
		BOOST = lerp(BOOST, ROAD_BOOST, 0.02);
	else:
		if (BOOST > 1):
			BOOST = lerp(BOOST, 1, 0.02);


func _on_ShootTimer_timeout():
	shoot_ready = true;
