extends CharacterBody3D

const SPEED: float = 160;
const DRAG: float = 0.8;
const JUMP_POWER: float = 4;
const GRAVITY: float = 7;

#Head Bob
const default_camera_pos := Vector3(0,0.5,0)
const BOB_FREQ := 2
const BOB_AMP := 0.08
var bob_t := 0.
@onready var X_rot := $X_rotation

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event:InputEvent)->void:
	if Input.is_action_just_pressed("Tab"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	var direction := Vector3(
		Input.get_axis("right", "left"),
		0,
		Input.get_axis("backward", "forward"),
	).normalized()
	
	var rotated_direction := -direction.rotated(Vector3.UP, X_rot.rotation.y)
	velocity += SPEED * delta * rotated_direction
	velocity *= Vector3(DRAG, 1, DRAG)
	if not is_on_floor():
		velocity.y += -GRAVITY*delta
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_POWER
	bob_t += delta*velocity.length()*float(is_on_floor())
	X_rot.position = head_bob(bob_t)
	move_and_slide()

func head_bob(time:float)->Vector3:
	var pos := Vector3.ZERO
	pos.y = sin(time*BOB_FREQ)*BOB_AMP
	pos.x = cos(time*BOB_FREQ/2)*BOB_AMP
	return pos+default_camera_pos