extends GCChunkSelector
class_name ChunkSelector

@export var max_repeat_category := 2
@export var difficulty_window := 0.3

func select_next(pool: Array, history: Array[StringName], context: Dictionary) -> Resource:
	var filtered := filter_pool(pool, history, context)
	if filtered.is_empty():
		filtered = pool
	if filtered.is_empty():
		return
	
	var cursor: float = context.get(&"difficulty_cursor", 0.0)
	var items: Array = []
	var weights: Array[float] = []
	
	for chunk in filtered:
		var diff: float = absf(chunk.difficulty - cursor)
		if diff <= difficulty_window:
			items.append(chunk)
			weights.append(1.0 / (diff + 0.1))
	
	if items.is_empty():
		return filtered[randi() % filtered.size()]
	
	return _weighted_pick(items, weights)
	
func filter_pool(pool: Array, history: Array[StringName], context: Dictionary) -> Array:
	var result: Array = super.filter_pool(pool, history, context)
	if history.size() < max_repeat_category:
		return result
	
	var recent: Array[StringName] = []
	for index in range(max(0, history.size() - max_repeat_category), history.size()):
		recent.append(history[index])
		
	var final: Array = []
	for chunk in result:
		if not recent.has(chunk.category):
			final.append(chunk)
	
	return final if not final.is_empty() else result

func _weighted_pick(items: Array, weights: Array[float]) -> Resource:
	var total := 0.0
	for weight in weights:
		total += weight
	
	var roll := randf() * total
	var running := 0.0
	
	for index in range(items.size()):
		running += weights[index]
		if roll <= running:
			return items[index]
			
	return items.back()
