extends  RefCounted
class_name Pid3D
var _p:float
var _i:float
var _d:float

var _prev_error:Vector3
var _error_integral:Vector3

var minimum_clamp :Vector3 = Vector3.ONE*-10
var maximum_clamp :Vector3 = Vector3.ONE*10

func _init(p:float,i:float,d:float)->void:
	_p = p
	_i = i
	_d = d

func update(error:Vector3, delta:float) -> Vector3:
	if error.length()<0.25:return Vector3.ZERO
	_error_integral += error*delta
	_error_integral = _error_integral.clamp(minimum_clamp, maximum_clamp)
	var _error_derivative := (error-_prev_error)/delta
	_prev_error = error

	return _p * error + _i * _error_integral + _d * _error_derivative

func reset() -> void:
	_error_integral = Vector3.ZERO
	#_prev_error = Vector3.ZERO
