class_name CharaControl_Input
extends CharaControl

# TODO: Pass arguments for a specific local player
func _init():
	pass

# TODO: Check specific local player
func update_chara_controls():
	var dir = 0.0
	if Input.is_action_pressed("player_move_left"):
		dir -= 1.0
	if Input.is_action_pressed("player_move_right"):
		dir += 1.0
	
	self.direction = dir
	self.pressed_jump = Input.is_action_pressed("player_move_jump")
