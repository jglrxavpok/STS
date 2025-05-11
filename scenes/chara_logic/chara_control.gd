class_name CharaControl
extends RefCounted

## ================ OUTPUT ================
## To be read by CharaBase to induce movement.

## Between -1 (left) and +1 (right)
var direction: float = 0

var pressed_jump: bool = false

## ================ METHODS ================

## To be overriden by derived classes. Called once per physic update,
## just before moving the corresponding character.
func update_chara_controls() -> void:
	pass
