@tool
class_name PathFindingComponent extends BaseComponent

func get_custom_class_name()->String:
	return "PathFindingComponent"

var nav_agent:NavigationAgent3D = NavigationAgent3D.new()


func _ready()->void:
	if not nav_agent: nav_agent = NavigationAgent3D.new()
	nav_agent.debug_enabled = true
	parent.physics_frame.connect(_physics_process)
	parent.call_deferred("add_child",nav_agent)
	nav_agent.target_position = Vector3(1000,0,0)

func _physics_process(delta:float)->void:
	if (not "MovementComponent" in parent.components
		or nav_agent.is_navigation_finished()
		or not nav_agent.is_inside_tree()):
			return
	walk_to(nav_agent.target_position,delta)

func walk_to(target:Vector3,delta:float)->void:
	if not "MovementComponent" in parent.components: return
	nav_agent.target_position = target
	if nav_agent.is_navigation_finished():
		return
	
	var direction:Vector3 = (nav_agent.get_next_path_position() - parent.global_position).normalized()
	parent.components["MovementComponent"].move(direction,delta)
