class_name CharaControl
extends Node


## ================ INPUTS ================
# Index of the player controlling this character, may be a CPU, or an online opponent, does not necessarily have a gamepad associated
var _player_index: int
var _character: STS_Character

## ================ METHODS ================

func _enter_tree():
	var parent = get_parent()
	assert(parent is STS_Character)
	_character = parent
	# Making sure CharaControl is run before STS_Character
	set_physics_process_priority(_character.get_physics_process_priority() - 1)

func _init(plyr_index: int) -> void:
	_player_index = plyr_index

func _physics_process(_delta: float) -> void:
	update_chara_controls(_character)

## To be overriden by derived classes. Called once per physic update,
## just before processing the corresponding character.
func update_chara_controls(_chara: STS_Character) -> void:
	pass
