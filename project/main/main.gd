extends ScrollContainer

signal race_changed(new_race: String)
signal class_changed(new_class: String)
signal level_changed(new_level: int)
signal level_up_finished

var level := 1 :
	set(value):
		level = maxi(1, value)
		level_changed.emit(level)
		_level_field.text = str(level)
var _leveling_up := false
var _load_path := ""

@onready var _stat_field : StatField = $VBoxContainer/StatField
@onready var _name_field : LineEdit = $VBoxContainer/NameField
@onready var _class_list : OptionButton = $VBoxContainer/CharacterOptions/ClassList
@onready var _race_list : OptionButton = $VBoxContainer/CharacterOptions/RaceList
@onready var _skill_container : SkillContainer = $VBoxContainer/SkillContainer
@onready var _dev_point_label : Label = $VBoxContainer/CharacterOptions/DevPointLabel
@onready var _log_label : Label = $VBoxContainer/CharacterOptions/LogLabel
@onready var _level_field : LineEdit = $VBoxContainer/CharacterOptions/Level
@onready var _level_up_button : Button = $VBoxContainer/CharacterOptions/LevelUpButton


func _ready() -> void:
	for race in _stat_field.RACES.keys():
		_race_list.add_item(race)
	for rolemaster_class in _skill_container.CLASS_LEVEL_BONUSES.keys():
		_class_list.add_item(rolemaster_class)
	_make_new()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open"):
		_open_file_dialog(_open)
	if Input.is_action_just_pressed("save"):
		_save()


func _on_save_button_pressed() -> void:
	_save()


func _clear() -> void:
	_name_field.clear()
	_stat_field.clear()
	_race_list.select(-1)
	_skill_container.clear()
	level = 1


func _save(to := _load_path) -> void:
	if to == "":
		to = "res://characters/%s.cfg" % [_name_field.text.to_snake_case()]
	
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
	
	_load_path = to


func _open(filepath: String) -> void:
	_clear()
	
	var file := ConfigFile.new()
	file.load(filepath)
	
	_stat_field.load_from(file.get_value("character", "stats", {}))
	_name_field.text = file.get_value("character", "name", "")
	
	level = file.get_value("character", "level", 1)
	_level_field.text = str(level)
	level_changed.emit(level)
	
	var race : String = file.get_value("character", "race", "")
	_select_item_by_text(_race_list, race)
	race_changed.emit(race)
	
	var character_class : String = file.get_value("character", "class", "")
	_select_item_by_text(_class_list, character_class)
	class_changed.emit(character_class)
	
	var skill_dict := {}
	if file.has_section("skills"):
		for skill_name in file.get_section_keys("skills"):
			skill_dict[skill_name] = file.get_value("skills", skill_name, 1)
	_skill_container.load_from(skill_dict)
	
	_load_path = filepath


func _select_item_by_text(option_button: OptionButton, text: String) -> void:
	for i in option_button.item_count:
		if option_button.get_item_text(i) == text:
			option_button.select(i)
			break


func _make_new() -> void:
	_clear()
	
	_stat_field.edit()


func _on_open_button_pressed() -> void:
	_open_file_dialog(_open)


func _open_file_dialog(function:Callable) -> void:
	var menu := PopupMenu.new()
	add_child(menu)
	menu.popup_centered(Vector2i(300, 200))
	for file in DirAccess.get_files_at("res://characters/"):
		menu.add_item(file.get_basename().get_file().capitalize())
	var index : int = await menu.index_pressed
	function.call(
		"res://characters/%s.cfg" % [menu.get_item_text(index).to_snake_case()]
	)
	menu.queue_free()


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
	_log_label.hide()
	level_up_finished.emit()
	_level_up_button.text = "Level Up"


func _level_up() -> void:
	level += 1
	_log_label.text = _stat_field.level_up()
	_log_label.show()
	var dev_points := _stat_field.get_dev_points()
	_dev_point_label.text = "Dev Points: %d" % [dev_points]
	_dev_point_label.show()
	_skill_container.level_up(dev_points)
	_leveling_up = true
	_level_up_button.text = "Finish Level Up"


func _on_skill_container_dev_points_updated(new_dev_points: int) -> void:
	_dev_point_label.text = "Dev Points: %d" % [new_dev_points]
