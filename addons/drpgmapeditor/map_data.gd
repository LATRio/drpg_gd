@tool
class_name MapData
extends Resource

@export var size: Vector2i
@export var data: PackedInt64Array
@export var start_pos: Vector2i


static func validate(map: Resource) -> bool:
	if not map is MapData:
		printerr("Loaded resource isn't MapData")
		return false
	if map.data.size() == 0:
		printerr("Loaded resource's data is empty")
		return false
	if map.size.x * map.size.y != map.data.size():
		printerr("Loaded resource's data has wrong size")
		return false
	return true


func map_to_world(pos: Vector2i) -> Vector2:
	return pos * Constants.CELL_SIZE


func world_to_map(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x) / Constants.CELL_SIZE, floori(pos.y) / Constants.CELL_SIZE)


func is_valid_v(pos: Vector2i) -> bool:
	return is_valid(pos.x, pos.y)


func is_valid(x: int, y: int) -> bool:
	return x >= 0 and x < size.x and y >= 0 and y < size.y


func can_pass(pos: Vector2i) -> bool:
	return is_valid_v(pos) and data[pos.y * size.x + pos.x] == 1


func set_cell_v(pos: Vector2i, type: int) -> void:
	set_cell(pos.x, pos.y, type)


func set_cell(x: int, y: int, type: int) -> void:
	if is_valid(x, y):
		data[y * size.x + x] = type


func get_cell_v(pos: Vector2i) -> int:
	return get_cell(pos.x, pos.y)


func get_cell(x: int, y: int) -> int:
	if is_valid(x, y):
		return data[y * size.x + x]
	else:
		return -1


func apply_resize(w: int, h: int) -> void:
	var new_data: PackedInt64Array = []
	new_data.resize(w * h)
	for y in range(h):
		for x in range(w):
			if x >= size.x or y >= size.y:
				new_data[y * w + x] = 0
			else:
				new_data[y * w + x] = data[y * size.x + x]
	data = new_data
	size.x = w
	size.y = h
