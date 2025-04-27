@tool
class_name PathFindingComponent extends BaseComponent

func get_custom_class_name() -> String:
	return "PathFindingComponent"

@export var target_node_path :NodePath

var nav_agent:NavigationAgent3D = NavigationAgent3D.new()
var target_node : Node

func _ready() -> void:
	target_node = parent.get_node(target_node_path)
	nav_agent.debug_enabled = true
	parent.physics_frame.connect(_physics_process)
	parent.call_deferred("add_child",nav_agent)
	if target_node:
		nav_agent.target_position = target_node.global_position

func _physics_process(delta:float) -> void:
	if (not "MovementComponent" in parent.components
		or not nav_agent.is_inside_tree()
		or not target_node):
			return
	walk_to(target_node.global_position,delta)

func walk_to(target:Vector3,delta:float) -> void:
	if not "MovementComponent" in parent.components: return
	nav_agent.target_position = target
	if nav_agent.is_navigation_finished():
		return
	
	var direction:Vector3 = (nav_agent.get_next_path_position() - parent.global_position).normalized()
	parent.components["MovementComponent"].move(direction,delta)
