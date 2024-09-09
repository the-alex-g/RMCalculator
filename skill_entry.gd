class_name SkillEntry
extends HBoxContainer

signal rank_changed

const MAX_RANK := 25

var skill : SkillContainer.Skill
var _spacers := 0
var _extra_bonus := 0 :
	set(value):
		_total_bonus -= _extra_bonus
		_extra_bonus = value
		_total_bonus += _extra_bonus
var _total_bonus := 0 :
	set(value):
		_total_bonus = value
		_bonus_label.text = "%s%d" % ["" if _total_bonus < 0 else "+", _total_bonus]

@onready var _add_tick_button : Button = $AddTick
@onready var _subtract_tick_button : Button = $SubtractTick
@onready var _tick_container : HBoxContainer = $TickBoxes
@onready var _bonus_label : Label = $Bonus


func _ready() -> void:
	$SkillName.text = skill.skill_name


func _on_subtract_tick_pressed() -> void:
	_remove_tick_box()


func _on_add_tick_pressed() -> void:
	_add_tick_box()


func _remove_tick_box() -> void:
	var last_child : Control = _tick_container.get_child(_tick_container.get_child_count() - 1)
	last_child.queue_free()
	if last_child.modulate == Color(1, 1, 1, 0):
		await get_tree().process_frame
		_spacers -= 1
		_remove_tick_box()
	rank_changed.emit()


func _add_tick_box(invisible := false) -> void:
	var tick_mark := TextureRect.new()
	tick_mark.texture = preload("res://tick_mark.png")
	tick_mark.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	if invisible:
		tick_mark.modulate = Color(1, 1, 1, 0)
	_tick_container.add_child(tick_mark)
	if (_tick_container.get_child_count() - _spacers) % 5 == 0:
		_add_tick_box(true)
		_spacers += 1
	rank_changed.emit()


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


func set_rank(rank: int) -> void:
	for i in rank:
		_add_tick_box()


func _on_delete_pressed() -> void:
	queue_free()


func get_rank() -> int:
	return _tick_container.get_child_count() - _spacers


func get_save_data() -> Dictionary:
	return {
		"rank":get_rank(),
		"bonus":_extra_bonus
	}


func load_from(data: Dictionary) -> void:
	set_rank(data["rank"])
	_extra_bonus = data["bonus"]
	$OtherBonus.text = str(_extra_bonus)


func _on_rank_changed() -> void:
	await get_tree().process_frame
	if get_rank() == MAX_RANK:
		_add_tick_button.disabled = true
	elif get_rank() == 0:
		_subtract_tick_button.disabled = true
	else:
		_subtract_tick_button.disabled = false
		_add_tick_button.disabled = false


func _on_other_bonus_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		_extra_bonus = int(new_text)
