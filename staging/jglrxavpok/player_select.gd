extends PanelContainer

@export var debounce_time: float = 0

var icon_index = 0
@onready var icons = [
	$Suzanne,
	$Tux,
	$Godette,
];
@onready var selection_label: Label = $SelectedLabel
var time = 0;
var debounced = true;
var last_input_time = 0;

var holding_left = false
var holding_right = false

func get_hovered_character() -> Sprite2D:
	return icons[icon_index]
	
func change_selected_player():
	selection_label.text = "Selected: "+get_hovered_character().name
	
func handle_inputs():
	var was_holding_left = holding_left
	var was_holding_right = holding_right
	if Input.is_action_just_pressed("ui_left"):
		icon_index -= 1
		debounced = false
		last_input_time = time
	elif Input.is_action_just_pressed("ui_right"):
		icon_index += 1
		debounced = false
		last_input_time = time
		
	if Input.is_action_just_pressed("ui_select"):
		change_selected_player()
	
	while(icon_index < 0):
		icon_index += icons.size()
	icon_index %= icons.size()

func _draw():
	var current_player_icon = get_hovered_character()
	var icon_rect = current_player_icon.get_rect()
	var icon_pos = current_player_icon.get_transform().get_origin()
	var icon_size = current_player_icon.get_rect().size
	
	var transformed_rect = get_canvas_transform() * Rect2(icon_pos-icon_size/2, icon_size)
	draw_rect(transformed_rect, Color.GREEN, false, 2.0)
	
func _process(delta: float) -> void:
	queue_redraw()
	time += delta
	handle_inputs()
	
	if time - last_input_time > debounce_time:
		debounced = true
