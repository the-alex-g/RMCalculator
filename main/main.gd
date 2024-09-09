extends Control

signal race_changed(new_race: String)
signal class_changed(new_class: String)
signal level_changed(new_level: int)

@onready var _stat_field : StatField = $VBoxContainer/StatField
@onready var _name_field : LineEdit = $VBoxContainer/NameField
@onready var _class_list : OptionButton = $VBoxContainer/HBoxContainer2/ClassList
@onready var _race_list : OptionButton = $VBoxContainer/HBoxContainer2/RaceList
@onready var _skill_container : SkillContainer = $VBoxContainer/SkillContainer


func _ready() -> void:
	for race in _stat_field.RACES.keys():
		_race_list.add_item(race)
	for rolemaster_class in _skill_container.CLASS_LEVEL_BONUSES.keys():
		_class_list.add_item(rolemaster_class)


func _on_save_button_pressed() -> void:
	_save()


func _clear() -> void:
	_name_field.clear()
	_stat_field.clear()
	_race_list.select(-1)


func _save() -> void:
	var save_file := ConfigFile.new()
	
	save_file.set_value("character", "stats", _stat_field.get_save_data())
	save_file.set_value("character", "name", _name_field.text)
	save_file.set_value("character", "race", _race_list.get_item_text(_race_list.selected))
	
	save_file.save("res://%s.role" % [_name_field.text.to_lower().replace(" ", "_")])
	
	_clear()


func _open(filepath: String) -> void:
	_clear()
	
	var file := ConfigFile.new()
	file.load(filepath)
	
	_stat_field.load_from(file.get_value("character", "stats", {}))
	_name_field.text = file.get_value("character", "name", "")
	for i in _race_list.item_count:
		if _race_list.get_item_text(i) == file.get_value("character", "race", ""):
			_race_list.select(i)
			break


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


func _on_race_list_item_selected(index: int) -> void:
	race_changed.emit(_race_list.get_item_text(index))


func _on_stat_field_bonuses_changed(new_bonuses: Dictionary) -> void:
	_skill_container.stats = new_bonuses


func _on_class_list_item_selected(index: int) -> void:
	class_changed.emit(_class_list.get_item_text(index))


func _on_level_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		var level := maxi(1, int(new_text))
		level_changed.emit(level)
