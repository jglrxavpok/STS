class_name CharacterDesc

var big_texture: Texture2D
var small_texture: Texture2D
var character_id: String
var scene: PackedScene
var physical_attack: PackedScene
var special_attack: PackedScene

# character_id: simple name for the character, used to reference it later in the game
# folder: folder to the files defining the character, must NOT end with '/'!
func _init(_character_id: String, folder: String) -> void:
	assert(!folder.ends_with("/"))
	self.character_id = _character_id
	big_texture = load(folder + "/icon.png")
	small_texture = load(folder + "/small_icon.png")
	scene = load(folder+"/"+_character_id+".tscn")
	if scene == null:
		scene = load("res://scenes/characters/kenney/kenney.tscn") # default scene in case a character is not finished
		
	# TODO: per character attacks
	physical_attack = load("res://scenes/characters/kenney/attacks/physical.tscn")
	special_attack = load("res://scenes/characters/kenney/attacks/special.tscn")
