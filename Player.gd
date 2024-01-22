class_name Player
extends Node3D

enum State {
	IDLE,
	MOVING,
}

@onready var yaw_handler: Node3D = $YawHandler
@onready var camera: Camera3D = $YawHandler/Camera3D

@export var move_speed := 8.0
@export var turn_speed := 6.0

var direction := Constants.Dir.NORTH
var state := State.IDLE

var map_data: MapData


func _process(delta: float) -> void:
	if Input.is_action_pressed("forward"):
		move_forward()
	elif Input.is_action_pressed("backward"):
		move_backward()
	elif Input.is_action_pressed("move_right"):
		move_right()
	elif Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("turn_right"):
		turn_right()
	elif Input.is_action_pressed("turn_left"):
		turn_left()


func move_forward() -> void:
	move(direction)


func move_backward() -> void:
	move(Constants.get_reverse_dir(direction))


func move_right() -> void:
	move(Constants.get_dir_right(direction))


func move_left() -> void:
	move(Constants.get_dir_left(direction))


func move(dir: Constants.Dir) -> void:
	if state == State.MOVING:
		return
	var dir_vec := Constants.get_dir_vector(dir)
	var cur_map_pos := map_data.world_to_map(Vector2(position.x, position.z))
	if not map_data.can_pass(cur_map_pos + Vector2i(dir_vec.x, dir_vec.z)):
		return
	set_state(State.MOVING)
	var tween := create_tween()
	var new_pos := position + Constants.get_dir_vector(dir) * Constants.CELL_SIZE
	tween.tween_property(self, "position", new_pos, Constants.CELL_SIZE / move_speed)
	tween.tween_callback(set_state.bind(State.IDLE))


func turn_right() -> void:
	turn_to_dir(Constants.get_dir_right(direction))


func turn_left() -> void:
	turn_to_dir(Constants.get_dir_left(direction))


func turn_to_dir(dir: Constants.Dir) -> void:
	if state == State.MOVING:
		return
	set_state(State.MOVING)
	var tween := create_tween()
	var new_angle := rotation.y + Constants.get_dir_vector(direction).signed_angle_to(Constants.get_dir_vector(dir), Vector3.UP)
	tween.tween_property(self, "rotation",Vector3(rotation.x, new_angle, rotation.z), (PI / 2.0) / turn_speed)
	tween.tween_callback(wrap_rotation)
	tween.tween_callback(set_state.bind(State.IDLE))
	direction = dir


func set_state(new_state: State) -> void:
	state = new_state


func wrap_rotation() -> void:
	rotation.x = wrapf(rotation.x, -PI, PI)
	rotation.y = wrapf(rotation.y, -PI, PI)
	rotation.z = wrapf(rotation.z, -PI, PI)
