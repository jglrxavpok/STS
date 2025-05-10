class_name CharaBase
extends CharacterBody3D

@export var speed: float = 10

enum Action {
	NONE,
	JUMP
}

var _inputdir: float = 0
var _inputaction: Action = Action.NONE

# Direction, must be between -1 (left) and +1 (right).
func set_input_direction(dir: float):
	_inputdir = dir

func set_input_action(action: Action):
	_inputaction = action
	
func _physics_process(delta: float) -> void:
	# Z-axis is irrelevant for physics
	velocity.x = _inputdir * speed
	velocity.z = 0
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= 9.81 * delta
	move_and_slide()
