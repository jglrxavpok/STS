extends Node

const PORT = 9999
var epeer = ENetMultiplayerPeer.new()

@export var player_to_spawn = preload("res://scenes/player_logic/player_logic.tscn")
@export var node_to_spawn_player: Node

signal multiplayer_ready

func _ready():
	pass

func on_join_game(id: int):
	multiplayer_ready.emit()
	if not multiplayer.is_server():
		return
	var player = player_to_spawn.instantiate()
	player.name = str(id)
	node_to_spawn_player.add_child(player)

func _on_main_ui_host_pressed(host: String) -> void:
	epeer.create_server(PORT)
	multiplayer.multiplayer_peer = epeer
	multiplayer.peer_connected.connect(on_join_game)
	on_join_game(1)

func _on_main_ui_join_pressed(host: String) -> void:
	epeer.create_client(host, PORT)
	multiplayer.multiplayer_peer = epeer
	on_join_game(multiplayer.get_unique_id())
