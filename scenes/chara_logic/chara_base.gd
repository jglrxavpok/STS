class_name CharaBase
extends CharacterBody3D

## ================ CONFIGURATION ================
## To be overriden for each character (= derived scenes). Constant during gameplay.

@export var speed: float = 10
@export var coyote_time: float = 0.2
@export var max_midair_jumps: int = 2

## ================ CONTROLS ================

## To be set only by the client having authority:
## dictates the character movements.
var ctrl: CharaControl = null

## ================ INTERNAL STATE ================
## Only useful for CharaBase the client has authority over.

var _time_since_floor: float = INF
var _midair_jump_count: int = 0
var _previous_pressed_jump: bool = false

## ================ METHODS ================
	
func _physics_process(delta: float) -> void:
	if ctrl:
		ctrl.update_chara_controls()
		
		# Z-axis is irrelevant for physics
		velocity.x = ctrl.direction * speed
		velocity.z = 0
		if is_on_floor():
			velocity.y = 0
			_time_since_floor = 0
			_midair_jump_count = 0
		else:
			velocity.y -= 20 * delta
			_time_since_floor += delta

		if ctrl.pressed_jump and not _previous_pressed_jump:
			if _time_since_floor <= coyote_time:
				velocity.y = 10
				_time_since_floor = INF
			else:
				if _midair_jump_count < max_midair_jumps:
					_midair_jump_count += 1
					velocity.y = 10
					_time_since_floor = INF
		_previous_pressed_jump = ctrl.pressed_jump

	move_and_slide()
