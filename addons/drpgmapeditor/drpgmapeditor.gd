@tool
extends EditorPlugin

const MAIN_SCREEN = preload("res://addons/drpgmapeditor/main_screen.tscn")
var main_screen_instance: Node

func _enter_tree() -> void:
	main_screen_instance = MAIN_SCREEN.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_screen_instance)
	_make_visible(false)


func _exit_tree() -> void:
	EditorInterface.get_editor_main_screen().remove_child(main_screen_instance)
	main_screen_instance.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if main_screen_instance:
		main_screen_instance.visible = visible


func _get_plugin_name():
	return "DRPG Map Editor"
