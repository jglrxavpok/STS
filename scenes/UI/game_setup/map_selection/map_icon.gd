extends VBoxContainer

class_name MapIcon

@export var level_id: String
var level: LevelDesc

func _ready():
	level = Levels.get_from_id(level_id)
	$Label.text = level.displayed_name
	$TextureRect.texture = level.thumbnail
