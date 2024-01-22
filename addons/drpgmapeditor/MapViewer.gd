@tool
class_name MapViewer
extends Control

@export var tile_size := 50.0

var _horz_edges: PackedVector2Array = []
var _vert_edges: PackedVector2Array = []

var can_draw := false
var map_data: MapData


func _ready() -> void:
	if map_data and not map_data.data.is_empty():
		can_draw = true
		update_edges()


func _process(delta: float) -> void:
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if not map_data:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				var cell_pos := viewer_to_map(event.position)
				map_data.set_cell_v(cell_pos, 1)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				var cell_pos := viewer_to_map(event.position)
				map_data.set_cell_v(cell_pos, 0)


func _draw() -> void:
	if can_draw:
		draw_cells()
		draw_edges()

func draw_cells() -> void:
	for y in range(map_data.size.y):
		for x in range(map_data.size.x):
			draw_rect(Rect2(Vector2i(x, y) * tile_size, Vector2(tile_size, tile_size)), Color.WHITE if map_data.get_cell(x, y) == 1 else Color.BLACK)


func draw_edges() -> void:
	if not _horz_edges.is_empty():
		draw_multiline(_horz_edges, Color.BLACK, 2.0)
	if not _vert_edges.is_empty():
		draw_multiline(_vert_edges, Color.BLACK, 2.0)


func set_map_data(data: MapData) -> void:
	map_data = data
	can_draw = true
	update_edges()


func update_edges() -> void:
	size = map_data.size * tile_size
	_vert_edges.clear()
	_horz_edges.clear()
	for x in range(map_data.size.x + 1):
		_vert_edges.push_back(Vector2(tile_size * x, 0) + Vector2.ONE)
		_vert_edges.push_back(Vector2(tile_size * x, tile_size * map_data.size.y) + Vector2.ONE)
	for y in range(map_data.size.y + 1):
		_horz_edges.push_back(Vector2(0, tile_size * y) + Vector2.ONE)
		_horz_edges.push_back(Vector2(tile_size * map_data.size.x, tile_size * y) + Vector2.ONE)


func viewer_to_map(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x) / tile_size, floori(pos.y) / tile_size)
