class_name SkillEntry
extends HBoxContainer

signal rank_changed(cost: int)

const MAX_RANK := 25

var skill : SkillContainer.Skill
var _extra_bonus := 0 :
	set(value):
		_total_bonus -= _extra_bonus
		_extra_bonus = value
		_total_bonus += _extra_bonus
var _total_bonus := 0 :
	set(value):
		_total_bonus = value
		_bonus_label.text = "%s%d" % ["" if _total_bonus < 0 else "+", _total_bonus]
var levels := 0
var _dev_points := 0 :
	set(value):
		_dev_points = value
		await get_tree().process_frame
		var cost := get_cost()
		_add_tick_button.disabled = not (cost <= _dev_points and cost > 0)
var _upgrades_this_level := 0 :
	set(value):
		print(value)
		_upgrades_this_level = value
		_subtract_tick_button.disabled = _upgrades_this_level == 0

@onready var _add_tick_button : Button = $AddTick
@onready var _subtract_tick_button : Button = $SubtractTick
@onready var _tick_container : HBoxContainer = $TickBoxes
@onready var _bonus_label : Label = $Bonus
@onready var _cost_field : LineEdit = $Cost


func _ready() -> void:
	$SkillName.text = skill.skill_name


func _on_subtract_tick_pressed() -> void:
	_remove_tick_box()


func _on_add_tick_pressed() -> void:
	_add_tick_box(Color.WHITE)


func _remove_tick_box() -> void:
	var last_child : Control = _tick_container.get_child(_tick_container.get_child_count() - 1)
	last_child.queue_free()
	_upgrades_this_level -= 1
	rank_changed.emit(-get_cost())


func _add_tick_box(color: Color) -> void:
	var tick_mark := TextureRect.new()
	tick_mark.texture = preload("res://skills/tick_mark.png")
	tick_mark.modulate = color
	# this provides spacing
	if get_rank() % 5 == 4:
		tick_mark.custom_minimum_size = Vector2(32, 0)
		tick_mark.size_flags_horizontal = Control.SIZE_SHRINK_END
		tick_mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tick_mark.stretch_mode = TextureRect.STRETCH_KEEP
	else:
		tick_mark.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	
	rank_changed.emit(get_cost())
	_upgrades_this_level += 1
	_tick_container.add_child(tick_mark)


func calculate_bonus(level: int, class_bonuses: Dictionary, stat_bonus: int) -> void:
	var bonus := _get_rank_bonus()
	if skill.category in class_bonuses:
		bonus += class_bonuses[skill.category] * level
	bonus += stat_bonus + _extra_bonus
	_total_bonus = bonus


func _get_rank_bonus() -> int:
	var bonus := 0
	for i in get_rank():
		if i < 10:
			bonus += 5
		elif i < 20:
			bonus += 2
		else:
			bonus += 1
	return bonus


func _on_delete_pressed() -> void:
	queue_free()


func get_rank() -> int:
	return _tick_container.get_child_count()


func get_save_data() -> Dictionary:
	return {
		"rank":get_rank(),
		"bonus":_extra_bonus,
		"cost":_cost_field.text
	}


func load_from(data: Dictionary) -> void:
	for i in data["rank"]:
		_add_tick_box(Color.BLACK)
	_extra_bonus = data["bonus"]
	_cost_field.text = data["cost"]
	$OtherBonus.text = str(_extra_bonus)


func _on_rank_changed(_cost: int) -> void:
	await get_tree().process_frame
	if get_rank() == MAX_RANK:
		_add_tick_button.disabled = true


func _on_other_bonus_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		_extra_bonus = int(new_text)


func on_new_level_started() -> void:
	_upgrades_this_level = 0


func on_level_finished() -> void:
	var rank := get_rank()
	for child in _tick_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	for x in rank:
		_add_tick_box(Color.BLACK)
	
	_add_tick_button.disabled = true
	_subtract_tick_button.disabled = true


func on_dev_points_changed(dev_points: int) -> void:
	_dev_points = dev_points


func get_cost() -> int:
	var cost_string := _cost_field.text
	# it's a twice-per-round upgrade
	if cost_string.contains("/"):
		var cost_array := cost_string.split("/")
		var cost := ""
		if _upgrades_this_level < cost_array.size():
			cost = cost_array[_upgrades_this_level]
		else:
			cost = cost_array[cost_array.size() - 1]
			if cost != "*":
				cost = "0"
		if cost == "*":
			cost = cost_array[cost_array.size() - 2]
		return int(cost)
	# it's a once-per-level upgrade
	elif _upgrades_this_level == 0:
		return int(cost_string)
	return 0
