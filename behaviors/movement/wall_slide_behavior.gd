extends GCBehavior
class_name WallSlideBehavior

@export_range(0.1, 1.0, 0.05) var slide_speed_modifier := 0.5
@export var scroll_driver_path: NodePath

var _driver: GCScrollDriver
var _is_sliding := false

func _init() -> void:
	phase = Phase.SENSE

func on_host_ready(host: Node) -> void:
	# find the Driver -> option 1:
	if not scroll_driver_path.is_empty():
		_driver = host.get_node_or_null(scroll_driver_path) as GCScrollDriver
	if _driver != null:
		return
	# find the Driver -> option 2:
	var node := host.get_parent()
	while node:
		for child in node.get_children():
			if child is GCScrollDriver:
				_driver = child
				return
		node = node.get_parent()

func on_physics(host: Node, _delta: float) -> void:
	if _driver == null or not (host is CharacterBody2D):
		return
	var sliding := (host as CharacterBody2D).is_on_wall()
	host.local_state[&"wall_sliding"] = sliding
	if sliding == _is_sliding:
		return;
	_is_sliding = sliding
	_driver.apply_speed_modifier(slide_speed_modifier if sliding else 1.0)
