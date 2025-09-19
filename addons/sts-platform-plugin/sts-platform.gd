@tool
@icon("res://addons/sts-platform-plugin/sts-platform-icon.png")
class_name STS_Platform extends AnimatableBody3D

@export var points: Array[Vector2] = []

func _ready() -> void:
	var prev = null
	for pt in points:
		if prev:
			var midpt = Vector3(prev.x + pt.x, prev.y + pt.y, 0) / 2
			var colshape = CollisionShape3D.new()
			colshape.translate(midpt)
			colshape.shape = BoxShape3D.new()
			colshape.shape.size = Vector3(pt.x - prev.x, pt.y - prev.y, 2)
			add_child(colshape)
		prev = pt


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_gizmos()
