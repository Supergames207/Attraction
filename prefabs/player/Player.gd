extends CharacterBody3D

const SPEED: float = 200;
const DRAG: float = 0.8;
const JUMP_POWER: float = 200;
const GRAVITY: float = 7;

@onready var X_rot = $X_rotation

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
	
	var rotated_direction = direction.rotated(Vector3.UP, X_rot.rotation.y)
	
	velocity += SPEED * delta * rotated_direction
	velocity *= Vector3(DRAG, 1, DRAG)
	move_and_slide()
