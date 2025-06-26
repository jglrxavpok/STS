extends Attack

var velocity: Vector2 = Vector2(0, 0)

func _on_start():
	var reversed = rotation.z < 0
	if reversed:
		velocity.x = -10;
	else:
		velocity.x = 10;

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	position.x += velocity.x * delta

func _on_effect_zone_body_entered(body: Node3D) -> void:
	if body is CharaBase and body != self.attacker:
		var knockback: Vector2;
		if velocity.x < 0:
			knockback.x = -15;
		else:
			knockback.x = 15;
		knockback.y = 2;
		damage(body as CharaBase, 2, knockback)
		end()
