@tool
@icon("res://addons/sts-platform-plugin/sts-platform-icon.png")
class_name STS_Platform extends Node3D

@export var points: Array[Vector3] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_gizmos()
