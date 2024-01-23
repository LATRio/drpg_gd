@tool
class_name MapViewer
extends Control

const TRACKED_BUTTONS := [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_MIDDLE]

@export var tile_size := 50.0

var _horz_edges: PackedVector2Array = []
var _vert_edges: PackedVector2Array = []

var can_draw := false
var map_data: MapData

var current_cell: Vector2i

var is_pressed := false
var pressed_btn := MOUSE_BUTTON_NONE


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
		if event.is_pressed() and press_button(event.button_index):
			if event.button_index == MOUSE_BUTTON_LEFT:
				var cell_pos := viewer_to_map(event.position)
				map_data.set_cell_v(cell_pos, 1)
				current_cell = cell_pos
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				var cell_pos := viewer_to_map(event.position)
				map_data.set_cell_v(cell_pos, 0)
				current_cell = cell_pos
			elif event.button_index == MOUSE_BUTTON_MIDDLE:
				# start drag
				pass
		elif event.is_released():
			depress_button(event.button_index)
	elif event is InputEventMouseMotion:
		if is_pressed:
			if pressed_btn == MOUSE_BUTTON_LEFT:
				var cell_pos := viewer_to_map(event.position)
				if current_cell != cell_pos:
					map_data.set_cell_v(cell_pos, 1)
					current_cell = cell_pos
			elif pressed_btn == MOUSE_BUTTON_RIGHT:
				var cell_pos := viewer_to_map(event.position)
				if current_cell != cell_pos:
					map_data.set_cell_v(cell_pos, 0)
					current_cell = cell_pos
			elif pressed_btn == MOUSE_BUTTON_MIDDLE:
				#drag
				pass


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
		draw_multiline(_horz_edges, Color.DARK_BLUE, 2.0)
	if not _vert_edges.is_empty():
		draw_multiline(_vert_edges, Color.DARK_BLUE, 2.0)


func set_map_data(data: MapData) -> void:
	map_data = data
	can_draw = true
	update_edges()


func update_edges() -> void:
	custom_minimum_size = map_data.size * tile_size
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


func press_button(button: int) -> bool:
	if not is_pressed and button in TRACKED_BUTTONS:
		is_pressed = true
		pressed_btn = button
		return true
	return false


func depress_button(button: int) -> void:
	if is_pressed and pressed_btn == button:
		is_pressed = false
		pressed_btn = MOUSE_BUTTON_NONE
