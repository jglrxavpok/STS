extends WorldEnvironment

@export var kenney_scene: PackedScene

func _ready():
	# TODO: test only
	Inputs.reset_mappings()
	Inputs.add_player_mapping(0, 0)
	Inputs.add_player_mapping(1, 1)
	
	GameFlow.select_character(0, "suzanne")
	GameFlow.select_character(1, "godette")
	for p in GameFlow.get_connected_player_indices():
		var character = GameFlow.get_selected_character(p)
		var instanced: CharaBase
		if character.scene != null:
			instanced = character.scene.instantiate() as CharaBase
		else:
			instanced = kenney_scene.instantiate() as CharaBase
		instanced.ctrl = CharaControl_Input.new(p)
		add_child(instanced)
		instanced.player_index = p
		instanced.global_position = Vector3(1 * p, 0, 0)
		
	# once all players are added, we can map the HUD to these players
	$Hud.setup()

func _physics_process(delta: float) -> void:
	pass
