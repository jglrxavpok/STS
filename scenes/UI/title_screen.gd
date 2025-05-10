extends Control


signal local_mode_chosen
signal multi_mode_chosen
signal training_mode_chosen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_local_button_pressed() -> void:
	local_mode_chosen.emit()

func _on_multi_button_pressed() -> void:
	multi_mode_chosen.emit()

func _on_training_button_pressed() -> void:
	training_mode_chosen.emit()
