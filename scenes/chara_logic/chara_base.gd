class_name CharaBase
extends CharacterBody3D

## ================ CONFIGURATION ================
## To be overriden for each character (= derived scenes).

@export var speed: float = 10
@export var coyote_time: float = 0.2

## ================ SYNCHRONIZATION STATE ================
## To be set explicitly by the authority's CharaDriver
## and implicitly by the multiplayer replication.

var sync_direction: float = 0 # between -1 (left) and +1 (right)
var sync_jump_pressed: bool = false

## ================ INTERNAL STATE ================
## Only useful for CharaBase the client has authority over.

var _time_since_floor: float = INF

## ================ FUNCTIONS ================
	
func _physics_process(delta: float) -> void:
	# Z-axis is irrelevant for physics
	velocity.x = sync_direction * speed
	velocity.z = 0
	if is_on_floor():
		velocity.y = 0
		_time_since_floor = 0
	else:
		velocity.y -= 20 * delta
		_time_since_floor += delta

	if sync_jump_pressed:
		if _time_since_floor <= coyote_time:
			velocity.y = 10
			_time_since_floor = INF

	move_and_slide()
