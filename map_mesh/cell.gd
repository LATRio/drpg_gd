class_name Cell
extends Node3D


func make_wall(dir: Constants.Dir) -> void:
	match dir:
		Constants.Dir.NORTH:
			load_and_add_wall("res://map_mesh/wall_north.tscn")
		Constants.Dir.EAST:
			load_and_add_wall("res://map_mesh/wall_east.tscn")
		Constants.Dir.SOUTH:
			load_and_add_wall("res://map_mesh/wall_south.tscn")
		Constants.Dir.WEST:
			load_and_add_wall("res://map_mesh/wall_west.tscn")
		_:
			return


func load_and_add_wall(path: String) -> void:
	add_child(load(path).instantiate())
