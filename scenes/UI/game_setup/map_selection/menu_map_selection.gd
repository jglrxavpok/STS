extends GenericCursor

@export var levels_container: GridContainer

@onready var label: Label = $VBoxContainer/Label

var levels: Array[String] = []
var row_count = 0
var controlling_player = -1

func _on_cursor_back() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/game_setup/menu_player_selection.tscn")
	
func _on_cursor_select() -> void:
	# TODO: proper map
	get_tree().change_scene_to_file("res://staging/jvernay/terrain.tscn")

func get_icon_rect(icon: Control) -> Rect2:
	var icon_pos = icon.get_global_transform().get_origin() - get_global_transform().get_origin()
	var icon_size = icon.get_rect().size
	
	var transformed_rect = get_canvas_transform().inverse() * Rect2(icon_pos, icon_size)
	return transformed_rect

func _ready() -> void:
	var first_player = Inputs.find_first_player()
	assert(first_player != -1, "We should not end up here with no player!")
	controlling_player = first_player
	label.text = "Player " + str(first_player+1) + " must select a level!"
	
	init_cursor(levels_container)

func get_input_full_name(action_name: String) -> String:
	return Inputs.get_player_input_name(controlling_player, action_name)

func _process(delta: float) -> void:
	queue_redraw()
	handle_movement(
		Input.is_action_just_pressed(get_input_full_name("ui_left")),
		Input.is_action_just_pressed(get_input_full_name("ui_right")),
		Input.is_action_just_pressed(get_input_full_name("ui_down")),
		Input.is_action_just_pressed(get_input_full_name("ui_up")),
		Input.is_action_just_pressed(get_input_full_name("ui_select")),
		Input.is_action_just_pressed(get_input_full_name("ui_back"))
	)

func _draw() -> void:
	super._draw()
