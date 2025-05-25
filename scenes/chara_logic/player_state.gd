extends Object

# State of a given player
class_name PlayerState

# Character the player is playing as
var desc: CharacterDesc
var player_id: int
var auth_id: int = -1

# Current damage of player
var damage: float = 0
var life_count: int = 3

func _init(_desc: CharacterDesc, _player_id: int) -> void:
	self.desc = _desc
	self.player_id = _player_id
