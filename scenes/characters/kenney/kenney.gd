extends CharaBase


var accum: float

func _process(delta: float) -> void:
	const NB_FRAMES = 2
	const FRAMES_PER_SEC = 6
	accum = fmod(accum + delta * FRAMES_PER_SEC, 1.0)
	var idx_anim = int(accum * NB_FRAMES)

	if velocity.x > 0:
		$Sprite3D.flip_h = false
	elif velocity.x < 0:
		$Sprite3D.flip_h = true

	if is_on_floor():
		if velocity.x > 0:
			$Sprite3D.frame = 7 + idx_anim
		elif velocity.x < 0:
			$Sprite3D.frame = 7 + idx_anim
		else:
			$Sprite3D.frame = 5
	else:
		if velocity.y > 0:
			$Sprite3D.frame = 6
		else:
			pass # Keep last frame
