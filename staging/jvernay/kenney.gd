extends CharacterBody3D

@export var speed = 10
@export var gravity = 10

var target_velocity = Vector3.ZERO

var init_pos = position

func _physics_process(delta: float) -> void:
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("player_move_left"):
		direction.z += 1
	if Input.is_action_pressed("player_move_right"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	target_velocity.z = direction.z * speed
	if not is_on_floor():
		target_velocity.y = -speed
	else:
		target_velocity.y = 0
	velocity = target_velocity
	move_and_slide()

	if position.y < -10:
		position = init_pos
