extends CharaBase

var dir = 1

func _process(delta: float) -> void:
	if velocity.x > 0:
		dir = 1
	elif velocity.x < 0:
		dir = -1
	

	if is_on_floor():
		if dir >= 1:
			$"3DMesh/AnimationPlayer".play("IdleR")	
		else:
			$"3DMesh/AnimationPlayer".play("IdleL")	
	else:
		if dir >= 1:
			$"3DMesh/AnimationPlayer".play("JumpR")	
		else:
			$"3DMesh/AnimationPlayer".play("JumpL")	
	# TODO: falling anim?
