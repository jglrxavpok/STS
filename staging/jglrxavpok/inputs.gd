extends Node2D

# inspired by https://www.reddit.com/r/godot/comments/13ikz4u/best_way_to_handle_controller_input_for_local/

# Takes all actions with a name starting with "player_template_" and creates actions for each player
# For instance "player_template_select" will be transformed into actions "player0_select", "player1_select", "player2_select", "player3_select"

const prefix = "player_template_"
const player_count = 4

func _ready():
	for template_action in InputMap.get_actions():
		if(not template_action.begins_with(prefix)):
			continue
		for player_index in range(player_count):
			var action_name = "player" + str(player_index) + "_" + template_action.substr(prefix.length())
			InputMap.add_action(action_name)
			for template_event in InputMap.action_get_events(template_action):
				var event = template_event.duplicate(true)
				event.set_device(player_index)
				InputMap.action_add_event(action_name, event)
		
