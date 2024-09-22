class_name StatField
extends GridContainer

signal bonuses_changed(new_bonuses: Dictionary)

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
const POTENTIAL_TABLE := {
	10:[25],
	20:[30],
	30:[35, 39],
	35:[38, 42, 59],
	40:[40, 45, 62],
	45:[42, 47, 64],
	49:[44, 49, 66],
	51:[46, 51, 68],
	53:[48, 53, 70],
	55:[50, 55, 71],
	57:[52, 57, 72, 74, 84],
	59:[54, 59, 73, 75, 85],
	61:[56, 61, 74, 76, 86],
	63:[58, 63, 75, 77, 87],
	65:[60, 65, 76, 78, 88],
	67:[62, 67, 77, 79, 88, 89],
	69:[64, 69, 78, 80, 89, 89],
	71:[66, 71, 79, 81, 89, 90],
	73:[68, 73, 80, 82, 90, 90],
	75:[70, 75, 81, 83, 90, 91],
	77:[72, 77, 82, 84, 91, 91],
	79:[74, 79, 83, 85, 91, 92],
	81:[76, 81, 84, 86, 92, 92],
	83:[78, 83, 85, 87, 92, 93],
	85:[80, 85, 86, 88, 93, 93, 94],
	87:[82, 86, 87, 89, 93, 94, 94],
	89:[84, 87, 88, 90, 94, 94, 95],
	90:[86, 88, 89, 91, 94, 95, 95, 97],
	91:[88, 89, 90, 92, 95, 95, 96, 97],
	92:[90, 90, 91, 93, 95, 96, 96, 97],
	93:[91, 91, 92, 94, 96, 96, 97, 98],
	94:[92, 92, 93, 95, 96, 97, 97, 98, 99],
	95:[93, 93, 94, 96, 97, 97, 98, 98, 99],
	96:[94, 94, 95, 97, 97, 98, 98, 99, 99],
	97:[95, 95, 96, 97, 98, 98, 99, 99, 99],
	98:[96, 96, 97, 98, 98, 99, 99, 99, 100],
	99:[97, 97, 98, 98, 99, 99, 100, 100, 100],
	100:[98, 98, 99, 99, 99, 100, 100, 100, 100, 101]
}
const STAT_GAIN_TABLE := {
	4:[],
	10:[1, 1, 1],
	15:[2, 2, 1, 1],
	20:[3, 3, 2, 1, 1],
	25:[4, 4, 2, 2, 1, 1],
	30:[5, 5, 3, 2, 2, 1, 1],
	35:[6, 5, 3, 2, 2, 1, 1, 1],
	40:[7, 6, 4, 3, 2, 1, 1, 1],
	45:[8, 6, 4, 3, 3, 2, 1, 1],
	50:[9, 7, 5, 3, 3, 2, 1, 1],
	55:[10, 7, 5, 4, 3, 2, 2, 1, 1],
	60:[11, 8, 6, 4, 4, 2, 2, 1, 1],
	65:[11, 8, 6, 4, 4, 3, 2, 1, 1],
	70:[12, 9, 7, 5, 4, 3, 2, 2, 1],
	75:[12, 9, 7, 5, 5, 3, 2, 2, 1],
	80:[13, 10, 8, 6, 5, 3, 3, 2, 1],
	85:[13, 10, 8, 6, 5, 4, 3, 2, 1],
	90:[14, 11, 9, 7, 6, 4, 3, 2, 1],
	95:[14, 11, 9, 7, 6, 4, 3, 2, 1],
	100:[15, 12, 10, 8, 6, 4, 3, 2, 1]
}

var _bonus_labels := {}
var _pot_edits := {}
var _temp_edits := {}
var _temps := {}
var _bonuses := {}
var _pots := {}
var _race := "Common Man"


func edit() -> void:
	clear()
	
	for stat in STATS:
		_add_label(stat)
		_temp_edits[stat] = _add_line_edit(stat, _on_temp_field_filled)
		_pot_edits[stat] = _add_line_edit(stat, _on_pot_field_filled)
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
		_temp_edits[stat] = _add_line_edit(stat, _on_temp_field_filled, str(temp))
		_pot_edits[stat] = _add_line_edit(stat, _on_pot_field_filled, str(pot))
		_add_line_edit(stat, _on_bonus_field_filled, str(bonus))
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


func _add_line_edit(stat: String, function: Callable, text:="") -> LineEdit:
	var line_edit := LineEdit.new()
	line_edit.max_length = 3
	line_edit.text = text
	add_child(line_edit)
	line_edit.text_changed.connect(function.bind(stat))
	return line_edit


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
	bonuses_changed.emit(get_total_bonuses())


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


func _on_pot_field_filled(new_text: String, stat: String) -> void:
	if new_text.is_valid_int():
		_pots[stat] = int(new_text)


func _on_main_race_changed(new_race: String) -> void:
	_race = new_race
	for stat in STATS:
		_update_bonuses(stat)


func _on_equal_pot_button_pressed() -> void:
	for stat in STATS:
		var temp : int = _temps.get_or_add(stat, -1)
		var pot_edit : LineEdit = _pot_edits[stat]
		if pot_edit.text == "" and temp != -1:
			pot_edit.text = str(temp)
			_pots[stat] = temp


func _on_auto_pot_button_pressed() -> void:
	for stat in STATS:
		var temp : int = _temps.get_or_add(stat, -1)
		var pot_edit : LineEdit = _pot_edits[stat]
		if pot_edit.text == "" and temp != -1:
			var potential := _generate_pot(temp)
			pot_edit.text = str(potential)
			_pots[stat] = potential


func _generate_pot(temp: int) -> int:
	var roll := randi_range(1, 100)
	for key : int in POTENTIAL_TABLE:
		if roll <= key:
			return _get_pot(temp, POTENTIAL_TABLE[key].duplicate())
	return temp


func _get_pot(temp: int, values: Array) -> int:
	var limits : Array[int] = [24, 39, 59, 74, 84, 89, 94, 97, 99, 200]
	for i in 10 - values.size():
		values.append(temp)
	for i in limits.size():
		if temp <= limits[i]:
			return values[i]
	return temp


func get_total_bonuses() -> Dictionary:
	return {
		SkillContainer.AG:_get_bonus("Agility"),
		SkillContainer.CO:_get_bonus("Constitution"),
		SkillContainer.SD:_get_bonus("Self-Discipline"),
		SkillContainer.ME:_get_bonus("Memory"),
		SkillContainer.RE:_get_bonus("Reasoning"),
		SkillContainer.ST:_get_bonus("Strength"),
		SkillContainer.QU:_get_bonus("Quickness"),
		SkillContainer.PR:_get_bonus("Presence"),
		SkillContainer.EM:_get_bonus("Empathy"),
		SkillContainer.IN:_get_bonus("Intuition")
	}


func level_up() -> String:
	var upgrades := ""
	for stat in STATS:
		var bonus := _upgrade_stat(stat)
		if bonus != 0:
			if upgrades != "":
				upgrades += ", "
			upgrades += "%s: +%d" % [stat, bonus]
	return upgrades


func _upgrade_stat(stat : String) -> int:
	var roll := randi_range(1, 100)
	var bonus := 0
	for threshold in STAT_GAIN_TABLE:
		if roll <= threshold:
			var stat_gain_list : Array = STAT_GAIN_TABLE[threshold]
			var difference : int = _pots[stat] - _temps[stat]
			if difference > 0:
				if difference == 1 and stat_gain_list.size() == 9:
					bonus = stat_gain_list[8]
				elif difference == 2 and stat_gain_list.size() >= 8:
					bonus = stat_gain_list[7]
				elif difference == 3 and stat_gain_list.size() >= 7:
					bonus = stat_gain_list[6]
				elif difference <= 5 and stat_gain_list.size() >= 6:
					bonus = stat_gain_list[5]
				elif difference <= 7 and stat_gain_list.size() >= 5:
					bonus = stat_gain_list[4]
				elif difference <= 9 and stat_gain_list.size() >= 4:
					bonus = stat_gain_list[3]
				elif difference <= 11 and stat_gain_list.size() >= 3:
					bonus = stat_gain_list[2]
				elif difference <= 14 and stat_gain_list.size() >= 2:
					bonus = stat_gain_list[1]
				elif stat_gain_list.size() > 0:
					bonus = stat_gain_list[0]
			break
	_temps[stat] += bonus
	_temp_edits[stat].text = str(_temps[stat])
	_update_bonuses(stat)
	return bonus


func get_dev_points() -> int:
	var total := 0
	for stat in ["Constitution", "Agility", "Self-Discipline", "Memory", "Reasoning"]:
		total += _calculate_dev_points(_temps[stat])
	return total


func _calculate_dev_points(temp : int) -> int:
	if temp <= 4:
		return 1
	elif temp <= 14:
		return 2
	elif temp <= 24:
		return 3
	elif temp <= 39:
		return 4
	elif temp <= 59:
		return 5
	elif temp <= 74:
		return 6
	elif temp <= 84:
		return 7
	elif temp <= 94:
		return 8
	elif temp <= 99:
		return 9
	elif temp <= 101:
		return 10
	else:
		return 11
