extends Control

class_name PlayerSelection

@export var movement_speed: float = 0.
@export var debounce_time: float = 0
@export var cursor_color: Color = Color.GREEN;
@export var player_index = 0
@export var portraits_container: GridContainer
@export var no_character_selected_texture: Texture2D
@export var waiting_for_join_texture: Texture2D

@onready var player_icon: TextureRect = $TextureRect
@onready var player_name_label: Label = $Label

var _joined = false
var icons: Array[CharacterPortrait] = []
var row_count = 0;
var hovered_cursor_pos = Vector2i(0, 0)
var selected_index = -1

func has_joined() -> bool:
	return _joined

func get_icon_rect(icon: CharacterPortrait) -> Rect2:
	var icon_pos = icon.get_global_transform().get_origin() - get_global_transform().get_origin()
	var icon_size = icon.get_rect().size
	
	var transformed_rect = get_canvas_transform().inverse() * Rect2(icon_pos, icon_size)
	return transformed_rect

func get_hovered_index() -> int:
	return hovered_cursor_pos.x + hovered_cursor_pos.y * portraits_container.columns

func get_hovered_character() -> CharacterPortrait:
	return icons[get_hovered_index()]
	
func get_selected_character() -> CharacterPortrait:
	if selected_index >= 0:
		return icons[selected_index]
	return null
	
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
	if Input.is_action_just_pressed(get_input_full_name("ui_left")):
		hovered_cursor_pos.x -= 1;
	elif Input.is_action_just_pressed(get_input_full_name("ui_right")):
		hovered_cursor_pos.x += 1;

	if Input.is_action_just_pressed(get_input_full_name("ui_up")):
		hovered_cursor_pos.y -= 1;
	elif Input.is_action_just_pressed(get_input_full_name("ui_down")):
		hovered_cursor_pos.y += 1;
		
	if Input.is_action_just_pressed(get_input_full_name("ui_back")):
		if selected_index == -1:
			leave()
		else:
			unselect_character()
				
	while(hovered_cursor_pos.x < 0):
		hovered_cursor_pos.x += portraits_container.columns
	hovered_cursor_pos.x %= portraits_container.columns
	
	while(hovered_cursor_pos.y < 0):
		hovered_cursor_pos.y += row_count
	hovered_cursor_pos.y %= row_count
			
	if Input.is_action_just_pressed(get_input_full_name("ui_select")):
		change_selected_player()
		
func join():
	_joined = true
	player_icon.texture = no_character_selected_texture
	
func leave():
	_joined = false
	player_icon.texture = waiting_for_join_texture
	Inputs.remove_player_mapping(player_index)
		
func _ready():
	for character in portraits_container.get_children():
		icons.append(character)
	row_count = int(ceil(icons.size() / float(portraits_container.columns)))
	player_name_label.text = "Player " + str(player_index+1)

func _draw():
	if not _joined:
		return
	var selected_character = get_selected_character()
	if(selected_character != null):
		draw_rect(get_icon_rect(selected_character), cursor_color, false, 4.0)
		
	var hovered_character = get_hovered_character()
	if(hovered_character != null):
		draw_rect(get_icon_rect(hovered_character), cursor_color, false, 10.0)
	
func _process(delta: float) -> void:
	if not _joined:
		return
	queue_redraw()
	handle_inputs(delta)
