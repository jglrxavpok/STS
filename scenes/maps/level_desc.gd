class_name LevelDesc

var thumbnail: Texture2D
var displayed_name: String
var level_id: String
var scene: PackedScene

# level_id: simple name for the level, used to reference it later in the game
# folder: folder to the files defining the level, must NOT end with '/'!
func _init(_level_id: String, folder: String) -> void:
	assert(!folder.ends_with("/"))
	self.level_id = _level_id
	thumbnail = load(folder + "/thumbnail.png")
	displayed_name = FileAccess.open(folder+"/name.txt", FileAccess.READ).get_as_text()
	scene = load(folder+"/"+_level_id+".tscn")
