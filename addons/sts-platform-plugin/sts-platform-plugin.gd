@tool
extends EditorPlugin

var gizmo_plugin = STS_PlatformGizmoPlugin.new()

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_node_3d_gizmo_plugin(gizmo_plugin)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_node_3d_gizmo_plugin(gizmo_plugin)
