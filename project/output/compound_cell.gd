@tool
class_name CompoundHeading
extends VBoxContainer

@export var title := "" :
	set(value):
		title = value
		_title_label.text = "- " + title + " -"
@export var sections : Array[String] = [] :
	set(value):
		sections = value
		for child in _section_container.get_children():
			child.queue_free()
		for section in sections:
			var label := Label.new()
			_section_container.add_child(label)
			label.text = section
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_section_container.columns = sections.size()

var _title_label := Label.new()
var _section_container := GridContainer.new()


func _init() -> void:
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_title_label, false, Node.INTERNAL_MODE_FRONT)
	add_child(_section_container, false, Node.INTERNAL_MODE_FRONT)


func add_element(item: Control) -> void:
	_section_container.add_child(item)
