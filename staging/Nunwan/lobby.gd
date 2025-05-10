extends Control

var peer = ENetMultiplayerPeer.new()
const PORT = 9999
@export var player_scene: PackedScene
@export var scene_to_add: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_player(id = 1):
	if not multiplayer.is_server():
		return
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func _on_host_pressed() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	hide()


func _on_join_pressed() -> void:
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer
	add_player(multiplayer.get_unique_id())
	hide()
