extends GCBehavior
class_name PlayerInputBehavior

@export var joystick: GCVirtualJoystick
@export var action_left: StringName = &"move_left"
@export var action_right: StringName = &"move_right"

func _init() -> void:
	phase = Phase.DECIDE
	
func on_physics(host: Node, _delta: float) -> void:
	var axis := 0.0
	if joystick and joystick.is_pressed:
		axis = joystick.direction.x
	else:
		axis = Input.get_axis(action_left, action_right)
	
	host.local_state[&"move_direction"] = Vector2(axis, 0)
	 
	if axis != 0.0:
		host.local_state[&"facing_direction"] = 1 if axis > 0.0 else -1
