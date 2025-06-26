extends Attack

@export var effect_zone: Area3D;
var reversed: bool = false

func _on_start():
	effect_zone.monitoring = true;
	reversed = rotation.z < PI/2
	
func _on_end():
	effect_zone.monitoring = false;


func _on_effect_zone_body_entered(body: Node3D) -> void:
	if body is CharaBase and body != self.attacker:
		var knockback: Vector2;
		if reversed:
			knockback.x = -30;
		else:
			knockback.x = 30;
		knockback.y = 2;
		damage(body as CharaBase, 1, knockback)
