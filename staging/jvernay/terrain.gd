extends WorldEnvironment

func _ready():
	$Kenney.ctrl = CharaControl_Input.new()

func _physics_process(delta: float) -> void:
	$SpotLight3D.look_at($Kenney.position)

	var dir = 0.0
	if Input.is_action_pressed("player_move_left"):
		dir -= 1.0
	if Input.is_action_pressed("player_move_right"):
		dir += 1.0
