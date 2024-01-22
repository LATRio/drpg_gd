class_name Constants

const CELL_SIZE := 2.0

enum Dir {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}


static func get_reverse_dir(dir: Dir) -> Dir:
	match dir:
		Dir.NORTH:
			return Dir.SOUTH
		Dir.SOUTH:
			return Dir.NORTH
		Dir.WEST:
			return Dir.EAST
		Dir.EAST:
			return Dir.WEST
		_:
			return Dir.NORTH


static func get_dir_right(dir: Dir) -> Dir:
	return wrapi(dir + 1, 0, 4)


static func get_dir_left(dir: Dir) -> Dir:
	return wrapi(dir - 1, 0, 4)


static func get_dir_vector(dir: Dir) -> Vector3:
	match dir:
		Dir.NORTH:
			return Vector3(0, 0, -1)
		Dir.SOUTH:
			return Vector3(0, 0, 1)
		Dir.WEST:
			return Vector3(-1, 0, 0)
		Dir.EAST:
			return Vector3(1, 0, 0)
		_:
			return Vector3()
