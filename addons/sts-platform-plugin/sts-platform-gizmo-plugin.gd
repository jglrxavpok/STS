@tool
class_name STS_PlatformGizmoPlugin extends EditorNode3DGizmoPlugin

func _get_gizmo_name() -> String:
	return "STS_Platform"

func _has_gizmo(node: Node3D) -> bool:
	return node is STS_Platform


func _init() -> void:
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")
	

var boxMesh = null
func _add_gizmo_line(gizmo: EditorNode3DGizmo, pt_a: Vector3, pt_b: Vector3, width: float = 0.1) -> void:
	if not boxMesh:
		boxMesh = BoxMesh.new()
	var a = pt_b - pt_a
	var b
	var c
	var vx = Vector3(1, 0, 0).dot(a)
	var vy = Vector3(0, 1, 0).dot(a)
	var vz = Vector3(0, 0, 1).dot(a)
	if vx > vy and vx > vz:
		b = Vector3(0, 1, 0) * width
		c = Vector3(0, 0, 1) * width
	elif vy > vx and vy > vz:
		b = Vector3(1, 0, 0) * width
		c = Vector3(0, 0, 1) * width
	else:
		b = Vector3(1, 0, 0) * width
		c = Vector3(0, 1, 0) * width
	var d = (pt_a + pt_b) / 2
	var t = Transform3D(a, b, c, d)
	gizmo.add_mesh(boxMesh, get_material("main", gizmo), t)

func _redraw(gizmo: EditorNode3DGizmo) -> void:
	if not boxMesh:
		boxMesh = BoxMesh.new()
	gizmo.clear()

	var node: STS_Platform = gizmo.get_node_3d()
	
	var prev = null
	for pt in node.points:
		var pt3 = Vector3(pt.x, pt.y, 0)
		if prev != null:
			# Godot makes the gizmo line translucid; twice to make it more opaque
			_add_gizmo_line(gizmo, prev, pt3, 0.3)
			_add_gizmo_line(gizmo, prev, pt3, 0.3)
		prev = pt3


	#gizmo.add_lines(lines, get_material("main", gizmo), false)
	#gizmo.add_handles(handles, get_material("handles", gizmo), [])
	#gizmo.add_unscaled_billboard(get_material("main", gizmo))
	
#func _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2) -> void:
	#var node: STS_Platform = gizmo.get_node_3d()
	#var from = camera.project_ray_origin(screen_pos)
	#var dir = camera.project_ray_normal(screen_pos)
	#var intersect = Plane(Vector3.BACK, node.global_position).intersects_ray(from, dir)
	#if intersect:
		#node.points[handle_id] = node.to_local(intersect)
