extends ScrollContainer

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


func _ready() -> void:
	load_from("res://characters/nuquerna.cfg")


func load_from(path: String) -> void:
	var file := ConfigFile.new()
	file.load(path)
	
	var race: String = file.get_value("character", "race", "")
	var rm_class: String = file.get_value("character", "class", "")
	var level: int  = file.get_value("character", "level", 1)
	$VBoxContainer/GridContainer/Name.text = "Character Name: " + file.get_value("character", "name", "")
	$VBoxContainer/GridContainer/Label.text = "Profession: " + rm_class
	$VBoxContainer/GridContainer/HBoxContainer/Label2.text = "Race: " + race
	$VBoxContainer/GridContainer/HBoxContainer/Label.text = "Level: %d" % [level]
	
	var stat_bonuses := {}
	
	var stat_info : Dictionary = file.get_value("character", "stats", {})
	for stat: String in StatField.STATS:
		var stat_dict : Dictionary = stat_info.get_or_add(stat, {"temp":0, "pot":0, "bonus":0})
		for s:String in [
			stat, _get_abbr(stat), str(stat_dict.temp), str(stat_dict.pot)
		]:
			var label := Label.new()
			label.text = s
			$VBoxContainer/HBoxContainer/Stats.add_child(label)
		
		if stat in ["Constitution", "Agility", "Self-Discipline", "Memory", "Reasoning"]:
			var label := Label.new()
			label.text = str(StatField.calculate_dev_points(stat_dict.temp))
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			$VBoxContainer/HBoxContainer/Stats.add_child(label)
		else:
			$VBoxContainer/HBoxContainer/Stats.add_child(Control.new())
		
		var normal := StatField.get_base_bonus(stat_dict.temp)
		var racial := StatField.get_racial_bonus(stat, race)
		var total : int = normal + racial + stat_dict.bonus
		stat_bonuses[stat] = total
		for i: int in [normal, racial, total]:
			
			var label := Label.new()
			label.text = str(i)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			$VBoxContainer/HBoxContainer/StatBonuses.add_element(label)
	
	if file.has_section("skills"):
		for skill_name in file.get_section_keys("skills"):
			var skill_dict : Dictionary = file.get_value("skills", skill_name, {})
			var skill : SkillContainer.Skill = SkillContainer.skill_dict[skill_name]
			var boxes : Array[HBoxContainer] = [HBoxContainer.new(), HBoxContainer.new(), HBoxContainer.new()]
			for box in boxes:
				$VBoxContainer/HBoxContainer2/Ranks.add_element(box)
			for i in skill_dict.rank:
				var tick := TextureRect.new()
				tick.custom_minimum_size = Vector2(0, 23)
				tick.texture = preload("res://skills/tick_mark.png")
				tick.modulate = Color.BLACK
				if i % 5 == 4:
					tick.custom_minimum_size = Vector2(32, 0)
					tick.size_flags_horizontal = Control.SIZE_SHRINK_END
					tick.size_flags_vertical = Control.SIZE_SHRINK_CENTER
					tick.stretch_mode = TextureRect.STRETCH_KEEP
				else:
					tick.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
				if i < 10:
					boxes[0].add_child(tick)
				elif i < 20:
					boxes[1].add_child(tick)
				else:
					boxes[2].add_child(tick)
			var label := Label.new()
			label.text = skill_name
			$VBoxContainer/HBoxContainer2/GridContainer.add_child(label)
			
			label = Label.new()
			label.text = skill_dict.cost
			$VBoxContainer/HBoxContainer2/GridContainer.add_child(label)
			
			label = Label.new()
			var rank_bonus := SkillEntry.get_rank_bonus(skill_dict.rank)
			label.text = str(rank_bonus)
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(label)
			
			label = Label.new()
			var stat_bonus := 0
			for stat in skill.stats:
				stat_bonus += stat_bonuses[STAT_NAMES[stat]]
			stat_bonus /= skill.stats.size()
			label.text = str(floor(stat_bonus))
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(label)
			
			label = Label.new()
			label.text = ""
			var level_bonus := 0
			if skill.category in SkillContainer.CLASS_LEVEL_BONUSES[rm_class]:
				level_bonus = SkillContainer.CLASS_LEVEL_BONUSES[rm_class][skill.category] * level
				label.text = str(level_bonus)
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(label)
			
			label = Label.new()
			label.text = str(skill_dict.item_bonus) if skill_dict.item_bonus != 0 else ""
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(label)
			
			label = Label.new()
			label.text = str(skill_dict.misc_bonus) if skill_dict.misc_bonus != 0 else ""
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(label)
			
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(Control.new())
			
			label = Label.new()
			label.text = str(skill_dict.item_bonus + skill_dict.misc_bonus + level_bonus + stat_bonus + rank_bonus)
			$VBoxContainer/HBoxContainer2/Bonuses.add_element(label)


func _get_abbr(stat: String) -> String:
	var abbr := ""
	if stat == "Self-Discipline":
		abbr = "SD"
	else:
		for x in 2:
			abbr += stat[x]
	return "(%s)" % [abbr.to_upper()]
