class_name Hits
extends VBoxContainer

var saved_value := 0
var rank := 0
var upgrades : Array[int] = []
var bonus := 0


func load_from(value: Vector3i) -> void:
	saved_value = value.x
	rank = value.y
	bonus = value.z
	_update_display()


func get_save_data() -> Vector3i:
	return Vector3i(_upgrade_value(), rank, bonus)


func upgrade(new_rank: int, new_bonus: int) -> void:
	bonus = new_bonus
	if new_rank > rank:
		upgrades.append(randi_range(1, 10))
	elif upgrades.size() > 0:
		upgrades.remove_at(upgrades.size() - 1)
	_update_display()


func _update_display() -> void:
	var hits := _upgrade_value()
	$Base.text = "Base Hits: %d" % [hits]
	$Total.text = "Total Hits: %d" % [calculate_total_hits(hits, bonus)]


func _upgrade_value() -> int:
	var value := saved_value
	for i in upgrades:
		value += i
	return value


static func calculate_total_hits(base: int, stat: int) -> int:
	return floori(base * (1.0 + stat / 100.0))
