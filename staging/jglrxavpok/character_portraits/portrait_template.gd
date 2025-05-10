extends Control

class_name CharacterPortrait

# Texture used for the player selection (bottom of screen)
@export var big_texture: Texture2D
# Texture used for the character list
@export var small_texture: Texture2D
@export var character_name: String

@onready var texture_rect = $TextureRect;

func _ready():
	texture_rect.texture = small_texture;
