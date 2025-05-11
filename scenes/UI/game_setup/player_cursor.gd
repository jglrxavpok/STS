extends GenericCursor

class_name PlayerSelection

@export var player_index = 0
@export var portraits_container: GridContainer
@export var no_character_selected_texture: Texture2D
@export var waiting_for_join_texture: Texture2D

@onready var player_icon: TextureRect = $TextureRect
@onready var player_name_label: Label = $Label

var _joined = false

func has_joined() -> bool:
	return _joined

func get_hovered_character() -> CharacterPortrait:
	return get_hovered_icon() as CharacterPortrait
	
func get_selected_character() -> CharacterPortrait:
	return get_selected_icon() as CharacterPortrait
	
func unselect_character():
	selected_index = -1
	player_icon.texture = no_character_selected_texture
	
func change_selected_player():
	var hovered = get_hovered_character()
	if(hovered != null):
		selected_index = get_hovered_index()
		player_icon.texture = hovered.big_texture
	
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
	
func _on_cursor_select():
	change_selected_player()
	
func _on_cursor_back():
	if selected_index == -1:
		leave()
	else:
		unselect_character()
		
func join():
	_joined = true
	player_icon.texture = no_character_selected_texture
	
func leave():
	_joined = false
	player_icon.texture = waiting_for_join_texture
	Inputs.remove_player_mapping(player_index)
		
func _ready():
	init_cursor(portraits_container)
	player_name_label.text = "Player " + str(player_index+1)

func _draw():
	if not _joined:
		return
	super._draw()
	
func _process(delta: float) -> void:
	if not _joined:
		return
	queue_redraw()
	handle_inputs(delta)
