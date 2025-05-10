extends CharacterBody3D

func _ready():
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 100
		velocity.x = input.x
		velocity.y = input.y
	move_and_slide()
