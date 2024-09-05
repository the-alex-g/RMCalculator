class_name StatField
extends GridContainer

const STATS := ["Constitution", "Agility", "Self-Discipline", "Memory", "Reasoning", "Strength", "Quickness", "Presence", "Empathy", "Intuition"]
const RACES := {
	"Common Man":{"Strength":5, "Self-Discipline":5},
	"High Man":{"Strength":10, "Quickness":-5, "Presence":10, "Constitution":10, "Agility":-5},
	"Half-Elf":{"Strength":5, "Quickness":10, "Presence":10, "Constitution":5, "Agility":5, "Self-Discipline":-10},
	"Wood Elf":{"Quickness":5, "Presence":5, "Empathy":5, "Agility":10, "Self-Discipline":-20, "Memory":5},
	"High Elf":{"Quickness":10, "Presence":10, "Empathy":5, "Agility":5, "Self-Discipline":-20, "Memory":5},
	"Fair Elf":{"Quickness":15, "Presence":15, "Empathy":5, "Agility":5, "Self-Discipline":-20, "Memory":5},
	"Dwarf":{"Strength":5, "Quickness":-5, "Presence":-10, "Empathy":-10, "Constitution":15, "Agility":-5, "Self-Discipline":5},
	"Halfling":{"Strength":-20, "Quickness":10, "Presence":-15, "Empathy":-5, "Constitution":15, "Agility":15, "Self-Discipline":-10},
	"Normal Orc":{"Strength":5, "Presence":-5, "Intuition":-10, "Empathy":-5, "Constitution":5, "Self-Discipline":-10, "Memory":-10, "Reasoning":-5},
	"Greater Orc":{"Strength":10, "Presence":-5, "Intuition":-5, "Empathy":-5, "Constitution":10, "Self-Discipline":-5, "Memory":-5, "Reasoning":-5},
	"Troll":{"Strength":15, "Quickness":-10, "Presence":-10, "Intuition":-10, "Empathy":-10, "Constitution":15, "Agility":-10, "Self-Discipline":-10, "Memory":-10, "Reasoning":-10}
}

var _bonus_labels := {}
var _temps := {}
var _bonuses := {}
var _pots := {}
var _race := "Common Man"


func edit() -> void:
	clear()
	
	for stat in STATS:
		_add_label(stat)
		_add_line_edit(stat, _on_temp_field_filled)
		_add_line_edit(stat)
		_add_line_edit(stat, _on_bonus_field_filled)
		_bonus_labels[stat] = _add_label()
		
		_update_bonuses(stat)


func load_from(dict: Dictionary) -> void:
	clear()
	for stat in STATS:
		var temp := 0
		var pot := 0
		var bonus := 0
		if stat in dict:
			if "temp" in dict[stat]:
				temp = dict[stat]["temp"]
			if "pot" in dict[stat]:
				pot = dict[stat]["pot"]
			if "bonus" in dict[stat]:
				bonus = dict[stat]["bonus"]
		
		_bonuses[stat] = bonus
		_temps[stat] = temp
		_pots[stat] = pot
		
		_add_label(stat)
		_add_label(str(temp))
		_add_label(str(pot))
		_add_label(_format_bonus(bonus))
		_bonus_labels[stat] = _add_label()
		
		_update_bonuses(stat)


func get_save_data() -> Dictionary:
	var save_dict := {}
	for stat in STATS:
		var stat_dict := {
			"temp":_temps.get_or_add(stat, 0),
			"pot":_pots.get_or_add(stat, 0),
			"bonus":_bonuses.get_or_add(stat, 0)
		}
		save_dict[stat] = stat_dict
	return save_dict


func clear() -> void:
	_bonus_labels.clear()
	_temps.clear()
	
	for i in get_child_count():
		if i >= columns:
			get_child(i).queue_free()


func _add_label(text := "") -> Label:
	var label := Label.new()
	label.text = text
	add_child(label)
	return label


func _add_line_edit(stat: String, function := func():) -> void:
	var line_edit := LineEdit.new()
	line_edit.max_length = 3
	add_child(line_edit)
	line_edit.text_changed.connect(function.bind(stat))


func _on_temp_field_filled(new_text: String, stat: String) -> void:
	if new_text.is_valid_int():
		_temps[stat] = int(new_text)
		_update_bonuses(stat)


func _format_bonus(bonus: int) -> String:
	if bonus > 0:
		return "+%d" % [bonus]
	elif bonus < 0:
		return str(bonus)
	return ""


func _update_bonuses(stat: String) -> void:
	var bonus := _get_bonus(stat)
	if bonus > 0:
		_bonus_labels[stat].text = "+%d" % [bonus]
	elif bonus < 0:
		_bonus_labels[stat].text = str(bonus)
	else:
		_bonus_labels[stat].text = ""


func _get_bonus(stat: String) -> int:
	var bonus := 0
	if stat in _temps:
		var temp : int = _temps[stat]
		if temp >= 102:
			bonus =  35
		elif temp == 101:
			bonus =  30
		elif temp == 100:
			bonus =  25
		elif temp >= 98:
			bonus =  20
		elif temp >= 95:
			bonus =  15
		elif temp >= 90:
			bonus =  10
		elif temp >= 75:
			bonus =  5
		elif temp >= 25:
			bonus =  0
		elif temp >= 10:
			bonus =  -5
		elif temp >= 5:
			bonus =  -10
		elif temp >= 3:
			bonus =  -15
		elif temp == 2:
			bonus =  -20
		else:
			bonus =  -25
	if stat in _bonuses:
		bonus += _bonuses[stat]
	return bonus + _get_racial_bonus(stat)


func _get_racial_bonus(stat: String) -> int:
	if _race in RACES:
		if stat in RACES[_race]:
			return RACES[_race][stat]
	return 0


func _on_bonus_field_filled(new_text: String, stat: String) -> void:
	if new_text.is_valid_int():
		_bonuses[stat] = int(new_text)
		_update_bonuses(stat)
