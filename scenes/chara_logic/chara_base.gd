class_name CharaBase
extends CharacterBody3D

## ================ CONFIGURATION ================
## To be overriden for each character (= derived scenes). Constant during gameplay.

@export var speed: float = 10
@export var coyote_time: float = 0.2
@export var max_midair_jumps: int = 2
@export var character_id: String

## ================ CONTROLS ================

## To be set only by the client having authority:
## dictates the character movements.
var ctrl: CharaControl = null
var player_index: int = -1

## ================ INTERNAL STATE ================
## Only useful for CharaBase the client has authority over.

var _time_since_floor: float = INF
var _midair_jump_count: int = 0
var _previous_pressed_jump: bool = false

var current_attack: Attack = null # used to wait for an attack to end before doing another
var chara_desc: CharacterDesc = null
var impulse: Vector2 = Vector2(0,0)

## ================ METHODS ================

func _ready() -> void:
	chara_desc = Characters.get_from_id(character_id)
	
func _physics_process(delta: float) -> void:
	if ctrl:
		# query inputs
		ctrl.update_chara_controls()
		
		# Move character
		# Z-axis is irrelevant for physics
		velocity.x = ctrl.direction * speed
		velocity.z = 0
		if is_on_floor():
			velocity.y = 0
			_time_since_floor = 0
			_midair_jump_count = 0
		else:
			velocity.y -= 20 * delta
			_time_since_floor += delta

		if ctrl.pressed_jump and not _previous_pressed_jump:
			if _time_since_floor <= coyote_time:
				velocity.y = 10
				_time_since_floor = INF
			else:
				if _midair_jump_count < max_midair_jumps:
					_midair_jump_count += 1
					velocity.y = 10
					_time_since_floor = INF
		_previous_pressed_jump = ctrl.pressed_jump
		
		# attack handling
		if current_attack == null:
			# start attack
			if ctrl.pressed_physical_attack:
				current_attack = chara_desc.physical_attack.instantiate()
				pass
			elif ctrl.pressed_special_attack:
				current_attack = chara_desc.special_attack.instantiate()
				pass
			if current_attack != null:
				if ctrl.direction < 0:
					current_attack.rotate_z(PI)
				current_attack.attacker = self
				if current_attack.follow_attacker:
					add_child(current_attack)
				else:
					current_attack.position = self.position
					get_parent().add_child(current_attack)
				current_attack.start()

	# TODO: actual physics and drag
	velocity.x += impulse.x
	velocity.y += impulse.y
	impulse.x *= 0.9
	impulse.y *= 0.9
	update_current_attack()
	move_and_slide()
	
func update_current_attack():
	if current_attack and not current_attack.is_active():
		current_attack = null
	pass

@rpc("any_peer", "call_local", "reliable")
func set_player_index(_player_id: int) -> void:
	player_index = _player_id
	set_multiplayer_authority(GameFlow.get_player_auth(player_index))
	if multiplayer.get_unique_id() == GameFlow.get_player_auth(player_index):
		ctrl = CharaControl_Input.new(player_index)
		print("set ctrl for %s pid %d aid %d" % [name, _player_id, multiplayer.get_unique_id()])

@rpc("authority", "call_local", "reliable")
func update_damage(new_damage: float):
	GameFlow.get_player_state(player_index).damage = new_damage
	# TODO: UI animation?

# TODO: is any peer valid here?
@rpc("any_peer", "call_local", "reliable")
func take_damage(damage_amount: float, knockback_speed: Vector2):
	var current_damage = GameFlow.get_player_state(player_index).damage
	var new_damage = current_damage + damage_amount
	impulse += knockback_speed # TODO: augment knockback based on current damage
	update_damage.rpc(new_damage)
	pass
