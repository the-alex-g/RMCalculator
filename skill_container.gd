class_name SkillContainer
extends VBoxContainer

enum {CO, AG, PR, EM, RE, IN, QU, ST, SD, ME}

const CLASS_LEVEL_BONUSES := {
	"Barbarian":{
		"Combat":3,
		"Athletic":2,
		"Body Dev.":2,
		"Outdoor":3
	},
	"Burglar":{
		"Combat":2,
		"Athletic":3,
		"Outdoor":1,
		"Perception":1,
		"Subterfuge":3
	},
	"Dancer":{
		"Combat":1,
		"Athletic":3,
		"Body Dev.":2,
		"Social":2,
		"Subterfuge":2
	},
	"Fighter":{
		"Combat":3,
		"Body Dev.":3,
		"Athletic":2,
		"Deadly":1,
		"Outdoor":1
	},
	"High Warrior Monk":{
		"Combat":3,
		"Athletic":2,
		"Body Dev.":2,
		"Concentration":1,
		"Deadly":2,
	},
	"No Profession":{
		"Academic":1,
		"Combat":1,
		"Athletic":1,
		"General":1,
		"Linguistic":1,
		"Magical":1,
		"Outdoor":1,
		"Perception":1,
		"Social":1,
		"Subterfuge":1
	},
	"Rogue":{
		"Combat":3,
		"Athletic":2,
		"Body Dev.":1,
		"General":1,
		"Outdoor":1,
		"Subterfuge":2
	},
	"Scholar":{
		"Academic":3,
		"Concentration":2,
		"General":1,
		"Linguistic":3,
		"Medical":1,
	}
}

var skills : Array[Skill] = [
	Skill.new("Body Development", [CO], "Body Dev."),
	Skill.new("Administration", [PR, EM], "Academic"),
	Skill.new("Advanced Math", [RE, ME], "Academic"),
	Skill.new("Alchemy", [RE, ME], "Academic"),
	Skill.new("Anthropology", [IN, EM], "Academic"),
	Skill.new("Architecture", [RE, ME], "Academic"),
	Skill.new("Astronomy", [ME, RE], "Academic"),
	Skill.new("Basic Math", [RE, ME], "Academic"),
	Skill.new("Biochemistry", [IN, RE], "Academic"),
	Skill.new("Boat Pilot", [ME, AG], "Academic"),
	Skill.new("Demon Lore", [ME, RE], "Academic"),
	Skill.new("Drafting", [RE, ME], "Academic"),
	Skill.new("Dragon Lore", [ME, RE], "Academic"),
	Skill.new("Engineering", [RE, ME], "Academic"),
	Skill.new("Faerie Lore", [ME, RE], "Academic"),
	Skill.new("Fauna Lore", [ME, RE], "Academic"),
	Skill.new("Flora Lore", [ME, RE], "Academic"),
	Skill.new("Heraldry", [ME, RE], "Academic"),
	Skill.new("Herb Lore", [ME, RE], "Academic"),
	Skill.new("Lock Lore", [ME, RE], "Academic"),
	Skill.new("Mapping", [ME, RE], "Academic"),
	Skill.new("Mechanition", [AG, RE], "Academic"),
	Skill.new("Metal Lore", [ME, RE], "Academic"),
	Skill.new("Military Organization", [PR, RE], "Academic"),
	Skill.new("Mining", [RE, IN], "Academic"),
	Skill.new("Navigation", [RE, IN], "Academic"),
	Skill.new("Philosophy/Religion", [ME, RE], "Academic"),
	Skill.new("Physics", [ME, RE], "Academic"),
	Skill.new("Planetology", [RE, EM], "Academic"),
	Skill.new("Poison Lore", [ME, RE], "Academic"),
	Skill.new("Racial History", [ME, RE], "Academic"),
	Skill.new("Sanity Healing Lore", [ME, RE], "Academic"),
	Skill.new("Siege Engineer", [RE, IN], "Academic"),
	Skill.new("Star-Gazing", [ME, IN], "Academic"),
	Skill.new("Stone Lore", [ME, RE], "Academic"),
	Skill.new("Tactics", [IN, RE], "Academic"),
	Skill.new("Trading Lore", [ME, RE], "Academic"),
	Skill.new("Weather-Watching", [IN, EM], "Academic"),
	Skill.new("Brawling", [RE, IN], "Combat"),
	Skill.new("Disarm Foe - Armed", [AG], "Combat"),
	Skill.new("Disarm Foe - Unarmed", [AG], "Combat"),
	Skill.new("Grappling Hook", [AG], "Combat"),
	Skill.new("Iaijitsu", [QU, AG], "Combat"),
	Skill.new("Lancing", [ST, AG], "Combat"),
	Skill.new("Manuever in Armor - Chain", [AG], "Combat"),
	Skill.new("Manuever in Armor - Plate", [AG], "Combat"),
	Skill.new("Manuever in Armor - Rigid Leather", [AG], "Combat"),
	Skill.new("Manuever in Armor - Soft Leather", [AG], "Combat"),
	Skill.new("Martial Arts - Strike", [ST, ST, AG], "Combat"),
	Skill.new("Martial Arts - Throws", [AG, AG, ST], "Combat"),
	Skill.new("Missile Artillery", [IN, AG], "Combat"),
	Skill.new("Reverse Stroke", [AG, RE], "Combat"),
	Skill.new("Stunned Manuevering", [SD], "Combat"),
	Skill.new("Subduing", [AG, QU], "Combat"),
	Skill.new("Tumbling Attack", [AG, ST], "Combat"),
	Skill.new("Tumbling Evasion", [AG, QU], "Combat"),
	Skill.new("Two Weapon Combo", [ST], "Combat"),
	Skill.new("Weapon Skills", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #1", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #2", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #3", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #4", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #5", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #6", [ST, ST, AG], "Combat"),
	Skill.new("Weapon Skills Cat #7", [ST, ST, AG], "Combat"),
	Skill.new("Yadomijitsu", [QU, AG], "Combat"),
	Skill.new("Acrobatics", [AG, QU], "Athletic"),
	Skill.new("Athletic Games", [ST, AG, QU], "Athletic"),
	Skill.new("Athletics - Agility", [AG], "Athletic"),
	Skill.new("Athletics - Endurance", [CO], "Athletic"),
	Skill.new("Athletics - Speed", [QU], "Athletic"),
	Skill.new("Athletics - Strength", [ST], "Athletic"),
	Skill.new("Climbing", [AG], "Athletic"),
	Skill.new("Contortions", [AG, SD], "Athletic"),
	Skill.new("Dance", [AG, IN], "Athletic"),
	Skill.new("Distance Running", [CO], "Athletic"),
	Skill.new("Diving", [SD, AG], "Athletic"),
	Skill.new("Flying/Gliding", [AG], "Athletic"),
	Skill.new("Juggling", [AG, IN], "Athletic"),
	Skill.new("Jumping", [ST, AG], "Athletic"),
	Skill.new("Pole Vaulting", [ST, AG], "Athletic"),
	Skill.new("Rappelling", [AG], "Athletic"),
	Skill.new("Rowing", [ST, SD], "Athletic"),
	Skill.new("Sailing", [AG, IN], "Athletic"),
	Skill.new("Skating", [AG, SD], "Athletic"),
	Skill.new("Skiing", [AG, SD], "Athletic"),
	Skill.new("Sprinting", [QU], "Athletic"),
	Skill.new("Stilt Walking", [ST, AG], "Athletic"),
	Skill.new("Surfing", [AG, SD], "Athletic"),
	Skill.new("Swimming", [AG], "Athletic"),
	Skill.new("Tightrope Walking", [AG, SD], "Athletic"),
	Skill.new("Tumbling", [AG, SD], "Athletic"),
	Skill.new("Adrenal Move - Balance", [PR, SD], "Concentration"),
	Skill.new("Adrenal Move - Landing", [PR, SD], "Concentration"),
	Skill.new("Adrenal Move - Leaping", [PR, SD], "Concentration"),
	Skill.new("Adrenal Move - Quick Draw", [PR, SD], "Concentration"),
	Skill.new("Adrenal Move - Speed", [PR, SD], "Concentration"),
	Skill.new("Adrenal Move - Strength", [PR, SD], "Concentration"),
	Skill.new("Body Damage Stabilize", [SD, EM], "Concentration"),
	Skill.new("Control Lycanthropy", [SD], "Concentration"),
	Skill.new("Dowsing", [EM], "Concentration"),
	Skill.new("Frenzy", [EM, SD], "Concentration"),
	Skill.new("Meditation", [PR, SD], "Concentration"),
	Skill.new("Meditation - Cleansing", [SD, EM], "Concentration"),
	Skill.new("Meditation - Death", [SD, PR], "Concentration"),
	Skill.new("Meditation - Healing", [SD, EM], "Concentration"),
	Skill.new("Meditation - Ki", [SD, PR], "Concentration"),
	Skill.new("Meditation - Sleep", [SD, IN], "Concentration"),
	Skill.new("Meditation - Trance", [SD, PR], "Concentration"),
	Skill.new("Mnemonics", [ME, SD], "Concentration"),
	Skill.new("Spacial Location Awareness", [IN], "Concentration"),
	Skill.new("Silent Kill", [AG, IN], "Deadly"),
	Skill.new("Use Poison", [AG, IN], "Deadly"),
	Skill.new("Advertising", [IN, RE], "General"),
	Skill.new("Appraisal", [RE, SD], "General"),
	Skill.new("Armor Evaluation", [IN, RE], "General"),
	Skill.new("Cookery", [RE, AG], "General"),
	Skill.new("Crafting", [AG, SD], "General"),
	Skill.new("Fletching", [AG, SD], "General"),
	Skill.new("Gimmickry", [IN, RE], "General"),
	Skill.new("Horticulture", [RE, EM], "General"),
	Skill.new("Leather Working", [AG, RE], "General"),
	Skill.new("Metal Evaluation", [IN, RE], "General"),
	Skill.new("Painting", [IN, AG], "General"),
	Skill.new("Play Instrument", [AG, ME], "General"),
	Skill.new("Play Instrument Cat #1", [AG, ME], "General"),
	Skill.new("Play Instrument Cat #2", [AG, ME], "General"),
	Skill.new("Play Instrument Cat #3", [AG, ME], "General"),
	Skill.new("Rope Mastery", [ME, AG], "General"),
	Skill.new("Sculpting", [IN, AG], "General"),
	Skill.new("Skinning", [AG, IN], "General"),
	Skill.new("Smithing", [ST, AG], "General"),
	Skill.new("Stone Crafts", [SD, AG], "General"),
	Skill.new("Stone Evaluation", [IN, RE], "General"),
	Skill.new("Tactical Games", [RE, ME], "General"),
	Skill.new("Weapon Evaluation", [IN, RE], "General"),
	Skill.new("Wood Crafts", [AG, EM], "General"),
	Skill.new("Lip Reading", [IN, RE], "Lingustic"),
	Skill.new("Mimicry", [IN, SD], "Lingustic"),
	Skill.new("Music", [AG, EM], "Lingustic"),
	Skill.new("Poetic Improvisation", [IN, RE], "Lingustic"),
	Skill.new("Propaganda", [IN, ME], "Lingustic"),
	Skill.new("Public Speaking", [EM, PR], "Lingustic"),
	Skill.new("Signaling", [ME, SD], "Lingustic"),
	Skill.new("Singing", [PR, IN], "Lingustic"),
	Skill.new("Tale Telling", [PR, ME], "Lingustic"),
	Skill.new("Trading", [RE, EM], "Lingustic"),
	Skill.new("Ventriloquism", [SD, IN], "Lingustic"),
	Skill.new("Attunement", [EM, IN], "Magical"),
	Skill.new("Channeling", [IN], "Magical"),
	Skill.new("Circle Lore", [ME, RE], "Magical"),
	Skill.new("Divination", [IN, EM], "Magical"),
	Skill.new("Magic Ritual", [RE, ME], "Magical"),
	Skill.new("Power Perception", [EM], "Magical"),
	Skill.new("Runes", [EM, IN], "Magical"),
	Skill.new("Symbol Lore", [ME, RE], "Magical"),
	Skill.new("Targeting Skill", [IN, AG], "Magical"),
	Skill.new("Warding Lore", [ME, RE], "Magical"),
	Skill.new("Animal Healing", [EM, PR], "Medical"),
	Skill.new("Diagnostics", [IN, RE], "Medical"),
	Skill.new("Drug Tolerance", [CO, SD], "Medical"),
	Skill.new("First Aid", [SD, EM], "Medical"),
	Skill.new("Hypnosis", [PR, SD], "Medical"),
	Skill.new("Midwifery", [EM, ME, IN], "Medical"),
	Skill.new("Second Aid", [SD, EM, IN], "Medical"),
	Skill.new("Surgery", [SD, EM, IN], "Medical"),
	Skill.new("Animal Handling", [EM, PR], "Outdoor"),
	Skill.new("Animal Training", [EM, PR], "Outdoor"),
	Skill.new("Beast Mastery", [EM, PR], "Outdoor"),
	Skill.new("Caving", [SD, RE], "Outdoor"),
	Skill.new("Driving", [AG, QU], "Outdoor"),
	Skill.new("Foraging", [IN, ME], "Outdoor"),
	Skill.new("Herding", [EM, PR], "Outdoor"),
	Skill.new("Hostile Environments", [AG, SD], "Outdoor"),
	Skill.new("Loading", [EM, RE], "Outdoor"),
	Skill.new("Region Lore", [RE, ME], "Outdoor"),
	Skill.new("Riding", [EM, AG], "Outdoor"),
	Skill.new("Scrounge", [IN, RE], "Outdoor"),
	Skill.new("Streetwise", [PR, IN], "Outdoor"),
	Skill.new("Detect Traps", [IN], "Perception"),
	Skill.new("Direction Sense", [IN, RE], "Perception"),
	Skill.new("General Perception", [IN, IN, RE], "Perception"),
	Skill.new("Lie Perception", [IN, RE], "Perception"),
	Skill.new("Locate Secret Opening", [IN, RE], "Perception"),
	Skill.new("Poison Perception", [IN, RE], "Perception"),
	Skill.new("Read Tracks", [IN, RE], "Perception"),
	Skill.new("Sense Ambush", [IN, RE], "Perception"),
	Skill.new("Sense Reality Warp", [IN, EM], "Perception"),
	Skill.new("Surveillance", [IN, SD], "Perception"),
	Skill.new("Time Sense", [IN, ME], "Perception"),
	Skill.new("Tracking", [IN, RE], "Perception"),
	Skill.new("Diplomacy", [PR, IN], "Social"),
	Skill.new("Duping", [PR], "Social"),
	Skill.new("Gambling", [ME, PR], "Social"),
	Skill.new("Interrogation", [RE, AG], "Social"),
	Skill.new("Leadership", [PR, RE], "Social"),
	Skill.new("Seduction", [EM, PR], "Social"),
	Skill.new("Acting", [PR, EM], "Subterfuge"),
	Skill.new("Begging", [PR, EM], "Subterfuge"),
	Skill.new("Bribery", [PR, RE], "Subterfuge"),
	Skill.new("Camouflage", [RE, IN], "Subterfuge"),
	Skill.new("Disarm Trap", [IN, AG], "Subterfuge"),
	Skill.new("Disguise", [PR, IN], "Subterfuge"),
	Skill.new("Falsification", [SD, RE], "Subterfuge"),
	Skill.new("Hide Item", [RE, IN], "Subterfuge"),
	Skill.new("Mimery", [AG, SD], "Subterfuge"),
	Skill.new("Pick Pockets", [AG, IN], "Subterfuge"),
	Skill.new("Picking Locks", [IN, RE, AG], "Subterfuge"),
	Skill.new("Set Traps", [RE, AG], "Subterfuge"),
	Skill.new("Stalking and Hiding", [AG, SD], "Subterfuge"),
	Skill.new("Trap-Building", [RE, EM], "Subterfuge"),
	Skill.new("Trickery", [PR, QU], "Subterfuge")
]
var _skill_dict := {}
var stats : Dictionary = {}
var rolemaster_class : String = "Barbarian"
var level := 1

@onready var _skill_selection_button : OptionButton = $HBoxContainer/OptionButton
@onready var _skill_container : VBoxContainer = $SkillContainer


class Skill:
	var skill_name : String
	var stats : Array
	var category : String
	
	func _init(sn:String, st:Array, cat:String)->void:
		skill_name = sn
		stats = st
		category = cat


func _ready() -> void:
	# this is a workaround for having built an array instead of a dict
	for skill in skills:
		_skill_dict[skill.skill_name] = skill
		_skill_selection_button.add_item(skill.skill_name)
	skills.clear()


func _get_stat_bonus(stat_list : Array) -> int:
	var bonus := 0.0
	for stat in stat_list:
		bonus += stats.get_or_add(stat, 0)
	return floori(bonus / stat_list.size())


func _add_skill(skill_name: String) -> SkillEntry:
	for skill_field : SkillEntry in _skill_container.get_children():
		if skill_field.skill.skill_name == skill_name:
			return
	
	var skill : Skill = _skill_dict[skill_name]
	
	var skill_field := preload("res://skill_entry.tscn").instantiate()
	skill_field.skill = skill
	skill_field.rank_changed.connect(_on_skill_field_rank_changed.bind(skill_field))
	_skill_container.add_child(skill_field)
	
	_calculate_bonus(skill_field)
	
	return skill_field


func _on_skill_field_rank_changed(skill_field: SkillEntry) -> void:
	await get_tree().process_frame
	_calculate_bonus(skill_field)


func _calculate_bonus(skill_field: SkillEntry) -> void:
	skill_field.calculate_bonus(
		level,
		CLASS_LEVEL_BONUSES[rolemaster_class],
		_get_stat_bonus(skill_field.skill.stats)
	)


func _on_main_class_changed(new_class: String) -> void:
	rolemaster_class = new_class


func _on_main_level_changed(new_level: int) -> void:
	level = new_level
	for skill_field in _skill_container.get_children():
		_calculate_bonus(skill_field)


func load_from(data:Dictionary) -> void:
	for skill_name : String in data:
		var skill_field := _add_skill(skill_name)
		skill_field.load_from(data[skill_name])


func get_save_data() -> Dictionary:
	var save_dict := {}
	for skill_field : SkillEntry in _skill_container.get_children():
		save_dict[skill_field.skill.skill_name] = skill_field.get_save_data()
	return save_dict


func clear() -> void:
	for child in _skill_container.get_children():
		child.queue_free()


func _on_option_button_item_selected(index: int) -> void:
	_add_skill(_skill_selection_button.get_item_text(index))
