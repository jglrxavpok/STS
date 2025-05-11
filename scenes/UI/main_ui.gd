extends Control

signal host_pressed(host: String)
signal join_pressed(host: String)

func toggle_menu():
	if $Menu.visible:
		$Menu.hide()
	else:
		$Menu.show()

func _on_menu_local_mode_chosen() -> void:
	toggle_menu()
	$PlayerSelectionScreen.show()

func _on_menu_multi_mode_chosen() -> void:
	toggle_menu()
	$MultiLobby.show()

func _on_menu_training_mode_chosen() -> void:
	pass # Replace with function body.
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not $Menu.visible:
			$MultiLobby.hide()
			$PlayerSelectionScreen.hide()
			toggle_menu()

func _on_multi_lobby_host_pressed(host: String) -> void:
	host_pressed.emit(host)

func _on_multi_lobby_join_pressed(host: String) -> void:
	join_pressed.emit(host)
