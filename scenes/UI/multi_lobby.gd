extends Control

signal host_pressed
signal join_pressed
	
func _on_host_pressed() -> void:
	host_pressed.emit($ColorRect/BoxContainer/LineEdit.text)

func _on_join_pressed() -> void:
	join_pressed.emit($ColorRect/BoxContainer/LineEdit.text)
