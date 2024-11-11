class_name Languages
extends VBoxContainer

@onready var _language_container : VBoxContainer = $LanguageContainer


func load_from(data: Array) -> void:
	for language in data:
		_add_language_field().load_from(language)


func get_save_data() -> Array:
	var data := []
	for language_field in _language_container.get_children():
		data.append(language_field.get_save_data())
	return data


func _on_new_language_pressed() -> void:
	_add_language_field()


func _add_language_field() -> LanguageEntry:
	var field := preload("res://languages/language_entry.tscn").instantiate()
	_language_container.add_child(field)
	return field
