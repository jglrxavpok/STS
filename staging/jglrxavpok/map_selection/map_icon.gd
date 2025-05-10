extends VBoxContainer

class_name MapIcon

@export var displayed_name: String
@export var scene_name: String
@export var thumbnail: Texture2D

func _ready():
	$Label.text = displayed_name
	$TextureRect.texture = thumbnail
