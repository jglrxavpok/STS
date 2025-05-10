extends WorldEnvironment

func _physics_process(delta: float) -> void:
	$SpotLight3D.look_at($Kenney.position)
