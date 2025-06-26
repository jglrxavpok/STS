extends Node3D
class_name Attack;

@export var follow_attacker: bool = false
@export var duration: float = 1.0;
@export var attacker: CharaBase = null # Who launched this attack?
var finished: bool = false
var remainingTime = 0.0;

# ==== "VIRTUALS" ====
func _on_start():
	pass
	
func _on_end():
	pass
	
# ====================

func damage(target: CharaBase, damage_amount: float, knockback_speed: Vector2):
	target.take_damage.rpc_id(target.get_multiplayer_authority(), damage_amount, knockback_speed)

func start():
	remainingTime = duration;
	finished = false;
	self.show()
	_on_start();
	pass
	
func end():
	self.hide()
	remainingTime = 0;
	finished = true
	_on_end()
	if get_parent() != null:
		get_parent().remove_child(self)
	
func is_active():
	return remainingTime > 0;
	
func _physics_process(delta: float) -> void:
	if remainingTime > 0:
		remainingTime -= delta
		if remainingTime <= 0:
			end()
	pass
