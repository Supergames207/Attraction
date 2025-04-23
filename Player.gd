extends RigidBody3D
class_name Player
var pid := Pid3D.new(1.0, 0.1 , 1.0)
const SPEED := 8

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event:InputEvent)->void:
    if Input.is_action_just_pressed("Tab"):
        if Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_CONFINED
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
    var input := Input.get_vector("ui_left","ui_right","ui_down","ui_up")
    var velocity_error = Vector3(input.x,0,input.y)-Vector3(linear_velocity.x,0,linear_velocity.z)
    var impulse = pid.update(velocity_error,delta)*0.005
    apply_central_impulse(impulse)

