extends ScrollContainer

signal race_changed(new_race: String)
signal class_changed(new_class: String)
signal level_changed(new_level: int)
signal level_up_finished

var level := 1 :
	set(value):
		level = maxi(1, value)
		level_changed.emit(level)
		$VBoxContainer/HBoxContainer2/Level.text = str(level)
var _leveling_up := false

@onready var _stat_field : StatField = $VBoxContainer/StatField
@onready var _name_field : LineEdit = $VBoxContainer/NameField
@onready var _class_list : OptionButton = $VBoxContainer/HBoxContainer2/ClassList
@onready var _race_list : OptionButton = $VBoxContainer/HBoxContainer2/RaceList
@onready var _skill_container : SkillContainer = $VBoxContainer/SkillContainer
@onready var _dev_point_label : Label = $VBoxContainer/HBoxContainer2/DevPointLabel


func _ready() -> void:
	for race in _stat_field.RACES.keys():
		_race_list.add_item(race)
	for rolemaster_class in _skill_container.CLASS_LEVEL_BONUSES.keys():
		_class_list.add_item(rolemaster_class)
	_make_new()


func _on_save_button_pressed() -> void:
	_open_file_dialog(FileDialog.FILE_MODE_SAVE_FILE, _save)


func _clear() -> void:
	_name_field.clear()
	_stat_field.clear()
	_race_list.select(-1)
	_skill_container.clear()


func _save(to:String) -> void:
	var save_file := ConfigFile.new()
	
	save_file.set_value("character", "stats", _stat_field.get_save_data())
	save_file.set_value("character", "name", _name_field.text)
	save_file.set_value("character", "race", _race_list.get_item_text(_race_list.selected))
	save_file.set_value("character", "level", level)
	save_file.set_value("character", "class", _class_list.get_item_text(_class_list.selected))
	
	var skill_save_data := _skill_container.get_save_data()
	for skill_name in skill_save_data:
		save_file.set_value("skills", skill_name, skill_save_data[skill_name])
	
	save_file.save(to)


func _open(filepath: String) -> void:
	_clear()
	
	var file := ConfigFile.new()
	file.load(filepath)
	
	_stat_field.load_from(file.get_value("character", "stats", {}))
	_name_field.text = file.get_value("character", "name", "")
	level = file.get_value("character", "level", 1)
	$VBoxContainer/HBoxContainer2/Level.text = str(level)
	level_changed.emit(level)
	_select_item_by_text(_race_list, file.get_value("character", "race", ""))
	race_changed.emit(file.get_value("character", "race", ""))
	_select_item_by_text(_class_list, file.get_value("character", "class", ""))
	class_changed.emit(file.get_value("character", "class", ""))
	
	var skill_dict := {}
	for skill_name in file.get_section_keys("skills"):
		skill_dict[skill_name] = file.get_value("skills", skill_name, 1)
	_skill_container.load_from(skill_dict)


func _select_item_by_text(option_button: OptionButton, text: String) -> void:
	for i in option_button.item_count:
		if option_button.get_item_text(i) == text:
			option_button.select(i)
			break


func _make_new() -> void:
	_clear()
	
	_stat_field.edit()


func _on_open_button_pressed() -> void:
	_open_file_dialog(FileDialog.FILE_MODE_OPEN_FILE, _open)


func _open_file_dialog(file_mode:FileDialog.FileMode, function:Callable) -> void:
	var file_dialog := FileDialog.new()
	add_child(file_dialog)
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.popup(get_viewport_rect())
	file_dialog.add_filter("*.role")
	file_dialog.file_mode = file_mode
	function.call(await file_dialog.file_selected)
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
		level = int(new_text)


func _on_level_up_button_pressed() -> void:
	if _leveling_up:
		_finish_level()
	else:
		_level_up()


func _finish_level() -> void:
	_leveling_up = false
	_dev_point_label.hide()
	$VBoxContainer/HBoxContainer2/LogLabel.hide()
	level_up_finished.emit()
	$VBoxContainer/HBoxContainer2/LevelUpButton.text = "Level Up"


func _level_up() -> void:
	level += 1
	$VBoxContainer/HBoxContainer2/LogLabel.text = _stat_field.level_up()
	$VBoxContainer/HBoxContainer2/LogLabel.show()
	var dev_points := _stat_field.get_dev_points()
	_dev_point_label.text = "Dev Points: %d" % [dev_points]
	_dev_point_label.show()
	_skill_container.level_up(dev_points)
	_leveling_up = true
	$VBoxContainer/HBoxContainer2/LevelUpButton.text = "Finish Level Up"


func _on_skill_container_dev_points_updated(new_dev_points: int) -> void:
	_dev_point_label.text = "Dev Points: %d" % [new_dev_points]
