class_name CharaBase
extends CharacterBody3D

@export var speed: float = 10
@export var coyote_time: float = 0.2

enum Action {
	NONE,
	JUMP
}

var _input_dir: float = 0
var _input_action: Action = Action.NONE

var _time_since_floor: float = INF

# Direction, must be between -1 (left) and +1 (right).
func set_input_direction(dir: float):
	_input_dir = dir

func set_input_action(action: Action):
	_input_action = action
	
func _physics_process(delta: float) -> void:
	# Z-axis is irrelevant for physics
	velocity.x = _input_dir * speed
	velocity.z = 0
	if is_on_floor():
		velocity.y = 0
		_time_since_floor = 0
	else:
		velocity.y -= 20 * delta
		_time_since_floor += delta
		print(_time_since_floor)
	
	match _input_action:
		Action.JUMP:
			if _time_since_floor <= coyote_time:
				velocity.y = 10
				_time_since_floor = INF
	
	_input_action = Action.NONE
	move_and_slide()
