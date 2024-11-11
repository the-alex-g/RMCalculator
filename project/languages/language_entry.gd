class_name LanguageEntry
extends HBoxContainer

var language : String :
	set(value):
		_name_field.text = value
	get():
		return _name_field.text.capitalize()
var spoken : String :
	set(value):
		_spoken_field.text = value
	get():
		return _spoken_field.text
var written : String :
	set(value):
		_written_field.text = value
	get():
		return _written_field.text

@onready var _name_field : LineEdit = $Name
@onready var _spoken_field : LineEdit = $Spoken
@onready var _written_field : LineEdit = $Written


func _on_delete_button_pressed() -> void:
	queue_free()


func get_save_data() -> Dictionary:
	return {
		"name":language,
		"spoken":spoken,
		"written":written
	}


func load_from(data: Dictionary) -> void:
	language = data.name
	spoken = data.spoken
	written = data.written
