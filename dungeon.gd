extends Node3D

const CELL = preload("res://map_mesh/cell.tscn")
const COLUMN = preload("res://map_mesh/column.tscn")

@export var map_data: MapData
var start_pos := Vector2i(2, 1)


func _ready() -> void:
	$Player.map_data = map_data
	$Player.position = Vector3(start_pos.x * Constants.CELL_SIZE + Constants.CELL_SIZE / 2.0, 0, start_pos.y * Constants.CELL_SIZE + Constants.CELL_SIZE / 2.0)
	for y in range(map_data.size.y):
		for x in range(map_data.size.x):
			place_walls(x, y)
	for y in range(map_data.size.y + 1):
		for x in range(map_data.size.x + 1):
			place_columns(x, y)


func place_walls(x: int, y: int) -> void:
	if map_data.get_cell(x, y) == 1:
		var cell := CELL.instantiate()
		if map_data.get_cell(x, y - 1) != 1: # up
			cell.make_wall(Constants.Dir.NORTH)
		if map_data.get_cell(x + 1, y) != 1: # right
			cell.make_wall(Constants.Dir.EAST)
		if map_data.get_cell(x, y + 1) != 1: # down
			cell.make_wall(Constants.Dir.SOUTH)
		if map_data.get_cell(x - 1, y) != 1: # left
			cell.make_wall(Constants.Dir.WEST)
		cell.position = Vector3(x * Constants.CELL_SIZE, 0, y * Constants.CELL_SIZE)
		add_child(cell)


func place_columns(x: int, y: int) -> void:
	var cells := 0
	#check top-left
	if map_data.get_cell(x - 1, y - 1) == 1:
		cells += 1
	#check top-right
	if map_data.get_cell(x, y - 1) == 1:
		cells += 1
	#check bottom-left
	if map_data.get_cell(x - 1, y) == 1:
		cells += 1
	#check bottom-right
	if map_data.get_cell(x, y) == 1:
		cells += 1
	if cells < 4:
		var column := COLUMN.instantiate()
		var world_pos := map_data.map_to_world(Vector2i(x, y))
		column.position = Vector3(world_pos.x, 0, world_pos.y)
		add_child(column)
