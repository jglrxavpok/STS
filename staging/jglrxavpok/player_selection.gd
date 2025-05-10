extends PanelContainer

@export var players_container: Control
@export var ready_container: Control
var player_list: Array[PlayerSelection] = []

func _ready() -> void:
	for player in players_container.get_children():
		player_list.append(player)

func handle_inputs() -> void:
	for player in player_list:
		if Input.is_action_just_pressed(player.get_input_full_name("menu")):
			print("READY!!")
			# TODO: switch to level select screen
			break
	

func _process(delta: float) -> void:
	# Check if all players have selected a character
	var all_ready = true
	for player in player_list:
		if player.get_selected_character() == null and player.has_joined():
			all_ready = false
	ready_container.visible = all_ready
	
	handle_inputs()
