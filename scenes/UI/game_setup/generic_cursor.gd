extends Control

class_name GenericCursor

# behavior when select is pressed
func _on_cursor_select() -> void:
	pass
	
# behavior when back is pressed
func _on_cursor_back() -> void:
	pass

@export var cursor_color: Color

var hovered_cursor_pos = Vector2i(0, 0)
var selected_index = -1
var columns: int
var rows: int
var icons: Array[Control] = []

func init_cursor(container: GridContainer) -> void:
	columns = container.columns
	for icon in container.get_children():
		icons.append(icon)
	rows = int(ceil(icons.size() / float(container.columns)))

func handle_movement(go_left: bool, go_right: bool, go_down: bool, go_up: bool, select: bool, back: bool) -> void:
	if go_left:
		hovered_cursor_pos.x -= 1;
	elif go_right:
		hovered_cursor_pos.x += 1;

	if go_up:
		hovered_cursor_pos.y -= 1;
	elif go_down:
		hovered_cursor_pos.y += 1;
		
	if back:
		_on_cursor_back()
				
	while(hovered_cursor_pos.x < 0):
		hovered_cursor_pos.x += columns
	hovered_cursor_pos.x %= columns
	
	while(hovered_cursor_pos.y < 0):
		hovered_cursor_pos.y += rows
	hovered_cursor_pos.y %= rows
			
	if select:
		_on_cursor_select()

# helpers
func get_icon_rect(icon: Control) -> Rect2:
	var icon_pos = icon.get_global_transform().get_origin() - get_global_transform().get_origin()
	var icon_size = icon.get_rect().size
	
	var transformed_rect = get_canvas_transform().inverse() * Rect2(icon_pos, icon_size)
	return transformed_rect

func get_hovered_index() -> int:
	return hovered_cursor_pos.x + hovered_cursor_pos.y * columns

func get_hovered_icon() -> Control:
	return icons[get_hovered_index()]
	
func get_selected_icon() -> Control:
	if selected_index >= 0:
		return icons[selected_index]
	return null

func _draw() -> void:
	var selected_icon = get_selected_icon()
	if(selected_icon != null):
		draw_rect(get_icon_rect(selected_icon), cursor_color, false, 4.0)
		
	var hovered_icon = get_hovered_icon()
	if(hovered_icon != null):
		draw_rect(get_icon_rect(hovered_icon), cursor_color, false, 10.0)
