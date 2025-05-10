extends Control

@export var movement_speed: float = 0.
@export var debounce_time: float = 0
@export var cursor_color: Color = Color.GREEN;
@export var player_index = 0
@export var portraits_container: GridContainer

@onready var player_icon: TextureRect = $TextureRect

var icons: Array[CharacterPortrait] = []
var row_count = 0;
var time = 0;
var debounced = true;
var last_input_time = 0;
var hovered_cursor_pos = Vector2i(0, 0)
var selected_index = -1

var holding_left = false
var holding_right = false

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
	
func change_selected_player():
	var hovered = get_hovered_character()
	if(hovered != null):
		selected_index = get_hovered_index()
		player_icon.texture = hovered.big_texture
	
func get_input(action_name: String):
	return "player" + str(player_index) + "_" + action_name
	
func handle_inputs(delta: float):
	if Input.is_action_just_pressed(get_input("ui_left")):
		hovered_cursor_pos.x -= 1;
	elif Input.is_action_just_pressed(get_input("ui_right")):
		hovered_cursor_pos.x += 1;

	if Input.is_action_just_pressed(get_input("ui_up")):
		hovered_cursor_pos.y -= 1;
	elif Input.is_action_just_pressed(get_input("ui_down")):
		hovered_cursor_pos.y += 1;
		
	while(hovered_cursor_pos.x < 0):
		hovered_cursor_pos.x += portraits_container.columns
	hovered_cursor_pos.x %= portraits_container.columns
	
	while(hovered_cursor_pos.y < 0):
		hovered_cursor_pos.y += row_count
	hovered_cursor_pos.y %= row_count
			
	if Input.is_action_just_pressed(get_input("ui_select")):
		change_selected_player()
		
func _ready():
	for character in portraits_container.get_children():
		icons.append(character)
	row_count = int(ceil(icons.size() / float(portraits_container.columns)))

func _draw():
	var selected_character = get_selected_character()
	if(selected_character != null):
		draw_rect(get_icon_rect(selected_character), cursor_color, false, 4.0)
		
	var hovered_character = get_hovered_character()
	if(hovered_character != null):
		draw_rect(get_icon_rect(hovered_character), cursor_color, false, 10.0)
	
func _process(delta: float) -> void:
	queue_redraw()
	time += delta
	handle_inputs(delta)
	
	if time - last_input_time > debounce_time:
		debounced = true
