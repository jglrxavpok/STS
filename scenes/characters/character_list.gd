extends Node

var _characters: Dictionary[String, CharacterDesc] = {}
		
func _ready() -> void:
	const prefix = "res://scenes/characters/"
	var dir = DirAccess.open(prefix)
	for character_id in dir.get_directories():
		_characters[character_id] = CharacterDesc.new(character_id, prefix+character_id)
	pass

func get_from_id(character_id: String) -> CharacterDesc:
	return _characters[character_id]
