extends Control

@onready var player_huds: Array[PlayerHud] = [
	$Players/Player1,
	$Players/Player2,
	$Players/Player3,
	$Players/Player4,
]

func setup() -> void:
	for hud in player_huds:
		hud.setup()

func _process(delta: float) -> void:
	# TODO: test only
	for i in range(player_huds.size()):
		player_huds[i].set_life_count(1 if i % 2 == 0 else 3)
	pass
