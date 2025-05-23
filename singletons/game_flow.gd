extends Node

# list of characters played, one per connected player (indexed via player_index)
var _player_states: Array[PlayerState] = []
var selected_level: LevelDesc

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
	
func _spawn_map_test():
	var map = preload("res://scenes/maps/placeholder/placeholder.tscn").instantiate()
	$/root/STS/Map.add_child(map)
	
func _spawn_charas_test():
	var p = 0
	for player in _player_states:
		if player == null:
			continue
		var chara = player.desc.scene.instantiate()
		chara.position = Vector3(1 * p, 0, 0)
		p += 1
		$/root/STS/Players.add_child(chara)
	
@rpc("any_peer", "call_local", "reliable")
func game_launched():
	$/root/STS/MainUI.visible = false
	$/root/STS/MainUI.process_mode = PROCESS_MODE_DISABLED

@rpc("any_peer", "call_local", "reliable")
func launch_game_test():
	if multiplayer.is_server():
		_spawn_map_test()
		_spawn_charas_test()
		game_launched.rpc()
