class_name CharaControl
extends RefCounted

## ================ INPUTS ================
# Index of the player controlling this character, may be a CPU, or an online opponent, does not necessarily have a gamepad associated
var player_index: int

## ================ OUTPUT ================
## To be read by CharaBase to induce movement.

## Between -1 (left) and +1 (right)
var direction: float = 0

var pressed_jump: bool = false
var pressed_physical_attack: bool = false
var pressed_special_attack: bool = false

## ================ METHODS ================
func _init(player_index: int) -> void:
	self.player_index = player_index

## To be overriden by derived classes. Called once per physic update,
## just before moving the corresponding character.
func update_chara_controls() -> void:
	pass
