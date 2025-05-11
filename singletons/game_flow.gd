extends Node

# list of characters played, one per connected player (indexed via player_index)
var _player_states: Array[PlayerState] = []

func _init() -> void:
	_player_states.resize(Inputs.player_count)
	
func select_character(player_index: int, chara_id: String) -> void:
	_player_states[player_index] = PlayerState.new(Characters.get_from_id(chara_id))
	
func unselect_character(player_index: int) -> void:
	_player_states[player_index] = null

func get_player_state(player_index: int) -> PlayerState:
	return _player_states[player_index]
		
func get_selected_character(player_index: int) -> CharacterDesc:
	var state = get_player_state(player_index)
	if state == null:
		return null
	return state.desc

# list of player indices corresponding to players which are connected
func get_connected_player_indices() -> Array[int]:
	var list: Array[int] = []
	for player_index in range(_player_states.size()):
		if _player_states[player_index] != null:
			list.append(player_index)
			
	return list
