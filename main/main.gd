extends Control

@onready var _stat_field : StatField = $VBoxContainer/StatField
@onready var _name_field : LineEdit = $VBoxContainer/NameField


func _on_save_button_pressed() -> void:
	_save()


func _clear() -> void:
	_name_field.clear()
	_stat_field.clear()


func _save() -> void:
	var save_file := ConfigFile.new()
	
	save_file.set_value("character", "stats", _stat_field.get_save_data())
	save_file.set_value("character", "name", _name_field.text)
	
	save_file.save("res://%s.role" % [_name_field.text.to_lower().replace(" ", "_")])
	
	_clear()


func _open(filepath: String) -> void:
	_clear()
	
	var file := ConfigFile.new()
	file.load(filepath)
	
	_stat_field.load_from(file.get_value("character", "stats", {}))
	_name_field.text = file.get_value("character", "name", "")


func _make_new() -> void:
	_clear()
	
	_stat_field.edit()


func _on_open_button_pressed() -> void:
	var file_dialog := FileDialog.new()
	add_child(file_dialog)
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.popup()
	file_dialog.add_filter("*.role")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_open(await file_dialog.file_selected)
	file_dialog.queue_free()


func _on_make_new_button_pressed() -> void:
	_make_new()
