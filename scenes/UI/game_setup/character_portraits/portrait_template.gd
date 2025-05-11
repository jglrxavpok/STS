extends Control

class_name CharacterPortrait

# Texture used for the player selection (bottom of screen)
var character: CharacterDesc
@export var character_id: String

@onready var texture_rect = $TextureRect;

func _ready():
	character = Characters.get_from_id(character_id)
	texture_rect.texture = character.small_texture;
