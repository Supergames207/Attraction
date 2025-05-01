@tool
class_name  Player extends BaseCreature

const SPEED: float = 8;
const DRAG: float = 0.8;
const JUMP_POWER: float = 10;

var GRAVITY: Vector3 = Vector3(0,-30,0);

@onready var X_rot := $X_rotation

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(_event:InputEvent)->void:
	if Input.is_action_just_pressed("Tab"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if Engine.is_editor_hint(): return
	var direction := Vector3(
		Input.get_axis("right", "left"),
		0,
		Input.get_axis("backward", "forward"),
	).normalized()
	
	var rotated_direction := -direction.rotated(Vector3.UP, X_rot.rotation.y)
	var velocity := rotated_direction#SPEED * 
	#velocity *= Vector3(DRAG, 1, DRAG)
	
	components["MovementComponent"].move(velocity,state.step)

#If we ever need to cast a ray from the camera
func ScreenPoint_to_ray(ray_l: float) -> Dictionary:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var cam: Camera3D = owner.get_node("X_rotation/Y_rotation/Camera3D")
	var mousepos := get_viewport().get_mouse_position()
	var origin := cam.project_ray_origin(mousepos)
	var end := origin + cam.project_ray_normal(mousepos) * ray_l
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	return result
