extends Node2D

const prefix = "player_template_"
const player_count = 4

# player index -> gamepad index, -1 if no gamepad is assigned
var _player2gamepad_mapping: Array[int] = []
# gamepad index -> player index, -1 if no gamepad is assigned
var _gamepad2player_mapping: Array[int] = []
var _action_simple_names = [] # list of "simple names" of action (ui_left, jump, shield, etc)

func _ready():
	_player2gamepad_mapping.resize(player_count)
	_player2gamepad_mapping.fill(-1)
	_gamepad2player_mapping.resize(player_count)
	_gamepad2player_mapping.fill(-1)
	
	# inspired by https://www.reddit.com/r/godot/comments/13ikz4u/best_way_to_handle_controller_input_for_local/

	# Takes all actions with a name starting with "player_template_" and creates actions for each player
	# For instance "player_template_select" will be transformed into actions "player0_select", "player1_select", "player2_select", "player3_select"
	for template_action in InputMap.get_actions():
		if(not template_action.begins_with(prefix)):
			continue
		var action_simple_name = template_action.substr(prefix.length())
		_action_simple_names.append(action_simple_name)
		for player_index in range(player_count):		
			var player_action_name = get_player_input_name(player_index, action_simple_name)
			InputMap.add_action(player_action_name)

			var gamepad_action_name = get_gamepad_input_name(player_index, action_simple_name)
			InputMap.add_action(gamepad_action_name)
			
			for template_event in InputMap.action_get_events(template_action):
				var gamepad_event = template_event.duplicate(true)
				gamepad_event.set_device(player_index)
				InputMap.action_add_event(gamepad_action_name, gamepad_event)
				
# Adds the mapping between a player and a gamepad
func add_player_mapping(player_index: int, gamepad_index: int) -> void:
	_gamepad2player_mapping[gamepad_index] = player_index
	_player2gamepad_mapping[player_index] = gamepad_index
	for simple_name in _action_simple_names:
		var player_action_fullname = get_player_input_name(player_index, simple_name)
		var gamepad_action_fullname = get_gamepad_input_name(gamepad_index, simple_name)
		for event in InputMap.action_get_events(gamepad_action_fullname):
			InputMap.action_add_event(player_action_fullname, event)
		
func remove_player_mapping(player_index: int) -> void:
	var old_gamepad_index = _player2gamepad_mapping[player_index]
	if(old_gamepad_index != -1):
		_gamepad2player_mapping[old_gamepad_index] = -1
	_player2gamepad_mapping[player_index] = -1
	for simple_name in _action_simple_names:
		var action_fullname = get_player_input_name(player_index, simple_name)
		InputMap.action_erase_events(action_fullname)
	
# Returns the name of the input action for the given gamepad
# You probably want to use get_player_input_name most of the time
func get_gamepad_input_name(gamepad_index: int, action_name: String) -> String:
	return "gamepad" + str(gamepad_index) + "_" + action_name
		
# Returns the name of the input action for the given player.
# This action MAY have no mapping if the player has not joined the game yet!
func get_player_input_name(player_index: int, action_name: String) -> String:
	return "player" + str(player_index) + "_" + action_name

func has_player_associated(gamepad_index: int) -> bool:
	return _gamepad2player_mapping[gamepad_index] != -1
