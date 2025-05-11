class_name CharaControl_Input
extends CharaControl

# List of action names corresponding to this local player
var _move_left_action_name: String
var _move_right_action_name: String
var _jump_action_name: String

func _init(_player_index: int):
	super._init(_player_index)
	_move_left_action_name = Inputs.get_player_input_name(player_index, "move_left")
	_move_right_action_name = Inputs.get_player_input_name(player_index, "move_right")
	_jump_action_name = Inputs.get_player_input_name(player_index, "jump")

func update_chara_controls():
	var dir = 0.0
	if Input.is_action_pressed(_move_left_action_name):
		dir -= 1.0
	if Input.is_action_pressed(_move_right_action_name):
		dir += 1.0
	
	self.direction = dir
	self.pressed_jump = Input.is_action_pressed(_jump_action_name)
