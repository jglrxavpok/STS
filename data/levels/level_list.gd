extends Node

var _levels: Dictionary[String, LevelDesc] = {}
		
func _ready() -> void:
	const prefix = "res://data/levels/"
	var dir = DirAccess.open(prefix)
	for level_id in dir.get_directories():
		_levels[level_id] = LevelDesc.new(level_id, prefix+level_id)
	pass

func get_from_id(level_id: String) -> LevelDesc:
	return _levels[level_id]
