extends Control

class_name PlayerHud

@export var player_index: int

@onready var hearts = [
	$Lives/Life1,
	$Lives/Life2,
	$Lives/Life3,
]

func get_character_of_player(index: int) -> CharacterDesc:
	# TODO
	return Characters.get_from_id("suzanne")

func setup() -> void:
	$PlayerNumber.text = str(player_index+1)
	$CharacterIcon.texture = get_character_of_player(player_index).small_texture

func change_damage(new_damage: float) -> void:
	$DamageIndicator.text = str(snapped(new_damage, 0.1)) + "%"
	# TODO: play anim?
	
func set_life_count(life_count: int) -> void:
	for i in range(hearts.size()):
		if i <= life_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
