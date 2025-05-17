extends GenericCursor

class_name PlayerSelection

@export var player_index = 0
@export var portraits_container: GridContainer
@export var no_character_selected_texture: Texture2D
@export var waiting_for_join_texture: Texture2D

@onready var player_icon: TextureRect = $TextureRect
@onready var player_name_label: Label = $Label

@export var joined = false # exported for replication

func has_joined() -> bool:
	return joined

func get_hovered_character() -> CharacterPortrait:
	return get_hovered_icon() as CharacterPortrait
	
func get_selected_character() -> CharacterPortrait:
	return get_selected_icon() as CharacterPortrait
		
func get_input_full_name(action_name: String):
	return Inputs.get_player_input_name(player_index, action_name)
	
func handle_inputs(delta: float):
	handle_movement(
		Input.is_action_just_pressed(get_input_full_name("ui_left")),
		Input.is_action_just_pressed(get_input_full_name("ui_right")),
		Input.is_action_just_pressed(get_input_full_name("ui_down")),
		Input.is_action_just_pressed(get_input_full_name("ui_up")),
		Input.is_action_just_pressed(get_input_full_name("ui_select")),
		Input.is_action_just_pressed(get_input_full_name("ui_back"))
	)
	
@rpc("authority", "call_local", "reliable")
func _select_character() -> void:
	var hovered = get_hovered_character()
	if(hovered != null):
		selected_index = get_hovered_index()
		GameFlow.select_character(player_index, hovered.character.character_id)
		update_visuals()

@rpc("authority", "call_local", "reliable")
func _unselect_character() -> void:
	selected_index = -1
	GameFlow.unselect_character(player_index)
	update_visuals()

func update_visuals() -> void:
	if not joined:
		player_icon.texture = waiting_for_join_texture	
		return
		
	if selected_index == -1:
		player_icon.texture = no_character_selected_texture
		return
		
	player_icon.texture = get_selected_character().character.big_texture
	
func _on_cursor_select():
	var hovered = get_hovered_character()
	if(hovered != null):
		_select_character.rpc()
	
func _on_cursor_back():
	if selected_index == -1:
		Inputs.remove_player_mapping(player_index)
		_leave.rpc() # tell everyone we are leaving
		set_multiplayer_authority(1) # give authority to server
	else:
		_unselect_character.rpc() # tell everyone we unselected a character
		
func join():
	joined = true
	update_visuals()
	
@rpc("authority", "call_local", "reliable")
func _leave() -> void:
	joined = false
	update_visuals()
		
func _ready():
	init_cursor(portraits_container)
	player_name_label.text = "Player " + str(player_index+1)

func _draw():
	if not joined:
		return
	super._draw()
	
func _process(delta: float) -> void:
	queue_redraw()
	if not joined:
		return
	handle_inputs(delta)
