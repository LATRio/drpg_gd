@tool
class_name RPGMapEditor
extends Control

@onready var save: Button = %Save
@onready var save_as: Button = %SaveAs
@onready var map_viewer: MapViewer = %MapViewer

var map_data: MapData
var map_data_path := ""


func _ready() -> void:
	pass


func _on_new_pressed() -> void:
	var map := MapData.new()
	map.size = Vector2i(1, 1)
	map.data = [0]
	map.start_pos = Vector2i()
	set_map_data(map, "")


func _on_open_pressed() -> void:
	%MapDataOpen.popup_centered(Vector2i(650, 450))


func _on_save_pressed() -> void:
	if not map_data_path.is_empty() and map_data:
		if ResourceSaver.save(map_data, map_data_path) != OK:
			printerr("Couldn't save")


func _on_save_as_pressed() -> void:
	%MapDataSave.popup_centered(Vector2i(650, 450))


func set_map_data(data: MapData, path: String) -> void:
	map_data = data
	map_data_path = path
	map_viewer.set_map_data(map_data)
	update_save_btn()
	update_start_pos_limits()
	%WidthValue.value = map_data.size.x
	%HeightValue.value = map_data.size.y


func update_save_btn() -> void:
	if map_data:
		save.disabled = map_data_path.is_empty()
		save_as.disabled = false
	else:
		save.disabled = true
		save_as.disabled = true


func update_start_pos_limits() -> void:
	%StartPosX.max_value = map_data.size.x - 1
	%StartPosY.max_value = map_data.size.y - 1


func update_map_viewer() -> void:
	pass


func _on_apply_new_size_pressed() -> void:
	map_data.apply_resize(%WidthValue.value, %HeightValue.value)
	map_viewer.update_edges()
	update_start_pos_limits()


func _on_map_data_open_file_selected(path: String) -> void:
	var load_data = load(path)
	if MapData.validate(load_data):
		set_map_data(load_data, path)


func _on_map_data_save_file_selected(path: String) -> void:
	if ResourceSaver.save(map_data, path) == OK:
		map_data_path = path
		update_save_btn()
	else:
		printerr("Couldn't save as")


func _on_start_pos_x_value_changed(value: float) -> void:
	map_data.start_pos.x = value


func _on_start_pos_y_value_changed(value: float) -> void:
	map_data.start_pos.y = value
