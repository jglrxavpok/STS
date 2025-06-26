extends Control

class_name PlayerHud

@export var player_index: int
var old_damage = -1

@onready var hearts = [
	$Lives/Life1,
	$Lives/Life2,
	$Lives/Life3,
]

func get_character_of_player(index: int) -> CharacterDesc:
	return GameFlow.get_selected_character(index)

func setup() -> void:
	var character_desc = get_character_of_player(player_index)
	if character_desc != null:
		$PlayerNumber.text = str(player_index+1)
		$CharacterIcon.texture = character_desc.small_texture
	else: # no associated player
		$PlayerNumber.text = "$"
		hide()
		
func _process(delta: float) -> void:
	if player_index == -1:
		return
	var state = GameFlow.get_player_state(player_index)
	if state == null:
		return
	var damage = state.damage
	if damage != old_damage:
		old_damage = damage
		$DamageIndicator.text = str(snapped(damage, 0.1)) + "%"	
		# TODO: play anim?

func set_life_count(life_count: int) -> void:
	for i in range(hearts.size()):
		if i <= life_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
