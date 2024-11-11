class_name PrintScreen
extends VBoxContainer

signal saved

const STAT_NAMES := {
	SkillContainer.IN:"Intuition",
	SkillContainer.EM:"Empathy",
	SkillContainer.AG:"Agility",
	SkillContainer.QU:"Quickness",
	SkillContainer.PR:"Presence",
	SkillContainer.ST:"Strength",
	SkillContainer.RE:"Reasoning",
	SkillContainer.ME:"Memory",
	SkillContainer.SD:"Self-Discipline",
	SkillContainer.CO:"Constitution"
}

@onready var _language_list_container : VBoxContainer = $ScrollContainer/PrintBody/HBoxContainer/VBoxContainer/HBoxContainer/Languages
@onready var _language_bonus_container : CompoundHeading = $ScrollContainer/PrintBody/HBoxContainer/VBoxContainer/HBoxContainer/CompoundHeading
@onready var _print_body : VBoxContainer = $ScrollContainer/PrintBody


func load_from(path: String) -> void:
	var file := ConfigFile.new()
	file.load(path)
	
	var race: String = file.get_value("character", "race", "")
	var rm_class: String = file.get_value("character", "class", "")
	var level: int  = file.get_value("character", "level", 1)
	$ScrollContainer/PrintBody/GridContainer/Name.text = "Character Name: " + file.get_value("character", "name", "")
	$ScrollContainer/PrintBody/GridContainer/Profession.text = "Profession: " + rm_class
	$ScrollContainer/PrintBody/GridContainer/HBoxContainer/Race.text = "Race: " + race
	$ScrollContainer/PrintBody/GridContainer/HBoxContainer/Level.text = "Level: %d" % [level]
	
	var stat_bonuses := {}
	
	var stat_info : Dictionary = file.get_value("character", "stats", {})
	for stat: String in StatField.STATS:
		var stat_dict : Dictionary = stat_info.get_or_add(stat, {"temp":0, "pot":0, "bonus":0})
		for s:String in [
			stat, _get_abbr(stat), str(stat_dict.temp), str(stat_dict.pot)
		]:
			var label := Label.new()
			label.text = s
			$ScrollContainer/PrintBody/HBoxContainer/Stats.add_child(label)
		
		if stat in ["Constitution", "Agility", "Self-Discipline", "Memory", "Reasoning"]:
			var label := Label.new()
			label.text = str(StatField.calculate_dev_points(stat_dict.temp))
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			$ScrollContainer/PrintBody/HBoxContainer/Stats.add_child(label)
		else:
			$ScrollContainer/PrintBody/HBoxContainer/Stats.add_child(Control.new())
		
		var normal := StatField.get_base_bonus(stat_dict.temp)
		var racial := StatField.get_racial_bonus(stat, race)
		var total : int = normal + racial + stat_dict.bonus
		stat_bonuses[stat] = total
		for i: int in [normal, racial, total]:
			
			var label := Label.new()
			label.text = str(i)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			$ScrollContainer/PrintBody/HBoxContainer/StatBonuses.add_element(label)
	
	if file.has_section("skills"):
		var i := 0
		var column := 1
		for skill_name in file.get_section_keys("skills"):
			i += 1
			if column == 1 and i > ceili(file.get_section_keys("skills").size() / 2.0):
				column = 2
			
			var skill_dict : Dictionary = file.get_value("skills", skill_name, {})
			var skill : SkillContainer.Skill = SkillContainer.skill_dict[skill_name]
			
			var skill_bonus_container := _get_skill_bonus_container(column)
			
			_get_skill_name_container(column).add_child(_get_label(skill_name))
			
			var rank_bonus := SkillEntry.get_rank_bonus(skill_dict.rank)
			skill_bonus_container.add_element(_get_label(str(rank_bonus)))
			
			var stat_bonus := 0
			for stat in skill.stats:
				stat_bonus += stat_bonuses[STAT_NAMES[stat]]
			stat_bonus /= skill.stats.size()
			skill_bonus_container.add_element(_get_label(str(floor(stat_bonus))))
			
			var label := Label.new()
			label.text = ""
			var level_bonus := 0
			if skill.category in SkillContainer.CLASS_LEVEL_BONUSES[rm_class]:
				level_bonus = SkillContainer.CLASS_LEVEL_BONUSES[rm_class][skill.category] * level
				label.text = str(level_bonus)
			skill_bonus_container.add_element(label)
			skill_bonus_container.add_element(_get_label(
				str(skill_dict.item_bonus) if skill_dict.item_bonus != 0 else ""
			))
			skill_bonus_container.add_element(_get_label(
				str(skill_dict.misc_bonus) if skill_dict.misc_bonus != 0 else ""
			))
			skill_bonus_container.add_element(Control.new())
			skill_bonus_container.add_element(_get_label(
				str(skill_dict.item_bonus + skill_dict.misc_bonus + level_bonus + stat_bonus + rank_bonus)
			))
	
	if file.has_section("languages"):
		for language in file.get_section_keys("languages"):
			_language_list_container.add_child(_get_label(language.capitalize()))
			
			var ranks : Vector2i = file.get_value("languages", language, Vector2i.ZERO)
			for rank in [ranks.x, ranks.y]:
				var label := _get_label(str(rank))
				label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				_language_bonus_container.add_element(label)
	
	var hits : Vector3i = file.get_value("character", "hits", Vector3i.ZERO)
	$ScrollContainer/PrintBody/HBoxContainer/VBoxContainer/Hits.text = "Total Hits: %d" % [
		Hits.calculate_total_hits(hits.x, hits.z)
	]


func _get_skill_bonus_container(col: int) -> CompoundHeading:
	return get_node("ScrollContainer/PrintBody/Skills/BonusesColumn%d" % [col])


func _get_skill_name_container(col: int) -> VBoxContainer:
	return get_node("ScrollContainer/PrintBody/Skills/SkillNameColumn%d" % [col])


func _get_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	return label


func _get_abbr(stat: String) -> String:
	var abbr := ""
	if stat == "Self-Discipline":
		abbr = "SD"
	else:
		for x in 2:
			abbr += stat[x]
	return "(%s)" % [abbr.to_upper()]


func save_jpg() -> void:
	await RenderingServer.frame_post_draw
	
	var image := get_tree().root.get_texture().get_image()
	image.crop(
		ceili(_print_body.size.x),
		ceili(_print_body.size.y)
	)
	image.save_jpg("res://mysave.jpg")
	saved.emit()


func _on_save_button_pressed() -> void:
	save_jpg()
