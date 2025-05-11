extends Object

# State of a given player
class_name PlayerState

# Character the player is playing as
var desc: CharacterDesc

# Current damage of player
var damage: float = 0
var life_count: int = 3

func _init(_desc: CharacterDesc) -> void:
	self.desc = _desc
