extends PanelContainer

@export var players_container: Control
@export var ready_container: Control
var player_list: Array[PlayerSelection] = []
var press_start: bool

func _ready() -> void:
	Inputs.reset_mappings()
	for player in players_container.get_children():
		player_list.append(player)
		
func find_first_free_player_slot() -> int:
	for player_index in range(player_list.size()):
		if not player_list[player_index].has_joined():
			return player_index
	return -1
	
# called by clients, ask server to add a player, linked to the gamepad with index "remote_gamepad_index" on the calling client
@rpc("any_peer", "call_local", "reliable")
func _attempt_add_player(remote_gamepad_index: int):
	var new_player_slot = find_first_free_player_slot()
	if new_player_slot != -1:
		# say that slot is now controlled by client
		var player_owner = multiplayer.get_remote_sender_id()
		player_list[new_player_slot].set_multiplayer_authority(player_owner)
		# tell everyone a new player joined
		_new_player_joined.rpc(new_player_slot, player_owner)
		# tell client that its attempt succeeded
		_new_local_player_accepted.rpc_id(player_owner, new_player_slot, remote_gamepad_index)

@rpc("authority", "call_local", "reliable")
func _new_local_player_accepted(player_index: int, local_gamepad_index: int) -> void:
	Inputs.add_player_mapping(player_index, local_gamepad_index)
	player_list[player_index].set_multiplayer_authority(multiplayer.get_unique_id())
		
# called by server when a new player joins, from any client
@rpc("authority", "call_local", "reliable")
func _new_player_joined(player_index: int, player_owner: int) -> void:
	player_list[player_index].join()
	GameFlow.set_player_auth(player_index, player_owner)
		
func handle_inputs() -> void:
	press_start = false
	for player in player_list:
		if Input.is_action_just_pressed(player.get_input_full_name("menu")):
			press_start = true
	
	# handle player joining logic (leave is done in player_cursor.gd)
	for gamepad_index in range(Inputs.player_count):
		if OS.has_feature("multi_test"):
			# TODO: DEBUG ONLY FOR MULTI ON SAME MACHINE
			if gamepad_index == 0 and not multiplayer.is_server():
				continue
			
			if gamepad_index == 1 and multiplayer.is_server():
				continue
			# TODO: END OF DEBUG
		
		if Input.is_action_just_pressed(Inputs.get_gamepad_input_name(gamepad_index, "ui_select")):
			if not Inputs.has_player_associated(gamepad_index):
				_attempt_add_player.rpc_id(1, gamepad_index) # ask server to add my player
	

func _process(delta: float) -> void:
	# Check if all players have selected a character
	var all_ready = true
	var joined_count = 0
	for player in player_list:
		if player.has_joined():
			joined_count += 1
			if player.get_selected_character() == null:
				all_ready = false
	if joined_count == 0:
		all_ready = false
	ready_container.visible = all_ready
	
	handle_inputs()
	if press_start and all_ready and OS.has_feature("map_test"):
		GameFlow.launch_game_test.rpc()
