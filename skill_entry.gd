class_name SkillEntry
extends HBoxContainer

signal rank_changed

const MAX_LEVEL := 25

var skill : SkillContainer.Skill
var _spacers := 0

@onready var _add_tick_button : Button = $AddTick
@onready var _subtract_tick_button : Button = $SubtractTick
@onready var _tick_container : HBoxContainer = $TickBoxes
@onready var _bonus_label : Label = $Bonus


func _ready() -> void:
	$SkillName.text = skill.skill_name


func _on_subtract_tick_pressed() -> void:
	_remove_tick_box()
	await get_tree().process_frame
	if _tick_container.get_child_count() == 0:
		_subtract_tick_button.disabled = true
	_add_tick_button.disabled = false


func _on_add_tick_pressed() -> void:
	_add_tick_box()
	await get_tree().process_frame
	if _tick_container.get_child_count() == MAX_LEVEL + _spacers:
		_add_tick_button.disabled = true
	_subtract_tick_button.disabled = false


func _remove_tick_box() -> void:
	var last_child : Control = _tick_container.get_child(_tick_container.get_child_count() - 1)
	last_child.queue_free()
	if last_child.modulate == Color(1, 1, 1, 0):
		await get_tree().process_frame
		_spacers -= 1
		_remove_tick_box()
	else:
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
	else:
		rank_changed.emit()


func calculate_bonus(level: int, class_bonuses: Dictionary, stat_bonus: int) -> void:
	var bonus := 0
	var tick_marks := _tick_container.get_child_count() - _spacers
	for i in tick_marks:
		if i < 10:
			bonus += 5
		elif i < 20:
			bonus += 2
		else:
			bonus += 1
	if skill.category in class_bonuses:
		bonus += class_bonuses[skill.category] * level
	bonus += stat_bonus
	_bonus_label.text = str(bonus)
