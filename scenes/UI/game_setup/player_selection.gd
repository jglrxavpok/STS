extends PanelContainer

@export var players_container: Control
@export var ready_container: Control
var player_list: Array[PlayerSelection] = []

func _ready() -> void:
	Inputs.reset_mappings()
	for player in players_container.get_children():
		player_list.append(player)
		
func find_first_free_player_slot() -> int:
	for player_index in range(player_list.size()):
		if not player_list[player_index].has_joined():
			return player_index
	return -1
		
func handle_inputs() -> void:
	for player in player_list:
		if Input.is_action_just_pressed(player.get_input_full_name("menu")):
			# TODO: change to proper filename
			get_tree().change_scene_to_file("res://scenes/UI/game_setup/map_selection/menu_map_selection.tscn")
			break
	
	# handle player joining logic (leave is done in player_cursor.gd)
	for gamepad_index in range(Inputs.player_count):
		if Input.is_action_just_pressed(Inputs.get_gamepad_input_name(gamepad_index, "ui_select")):
			if not Inputs.has_player_associated(gamepad_index):
				var new_player_slot = find_first_free_player_slot()
				if new_player_slot != -1:
					Inputs.add_player_mapping(new_player_slot, gamepad_index)
					player_list[new_player_slot].join()
	

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
