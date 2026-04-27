extends Node2D
class_name GameWorld

@onready var world_controller := get_node("GCWorldController") as GCWorldController
@onready var scroll_driver := get_node("GCScrollDriver") as GCScrollDriver
@onready var player := get_node("Player") as GCCharacterHost2D
@onready var camera := get_node("GCCamera2D") as GCCamera2D
@onready var parallax := get_node_or_null("ParallaxBackground") as ParallaxBackground

func open_with_context(game_context: GCGameContext) -> void:
	world_controller.configure(game_context)
	world_controller.open_world()

func close_world() -> void:
	world_controller.close_world()
	scroll_driver.reset()
	
func get_chunk_source() -> GCStreamChunkSource:
	return scroll_driver.chunk_source as GCStreamChunkSource
	
func get_player_input() -> PlayerInputBehavior:
	for child in player.get_children():
		if child is PlayerInputBehavior:
			return child
	return null

func get_player_health() -> GCHealth:
	for child in player.get_children():
		if child is GCHealth:
			return child
	return null

func _physics_process(delta: float) -> void:
	if parallax and scroll_driver.active:
		parallax.scroll_offset.y -= scroll_driver.current_speed * delta
