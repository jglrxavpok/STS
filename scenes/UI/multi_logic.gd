extends Node

const PORT = 9999
var epeer = ENetMultiplayerPeer.new()

signal multiplayer_ready(id: int)

func _ready():
	pass

func on_join_game(id: int):
	multiplayer_ready.emit(id)

func _on_main_ui_host_pressed(host: String) -> void:
	epeer.create_server(PORT)
	multiplayer.multiplayer_peer = epeer
	on_join_game(1)

func _on_main_ui_join_pressed(host: String) -> void:
	epeer.create_client(host, PORT)
	multiplayer.multiplayer_peer = epeer
	on_join_game(multiplayer.get_unique_id())
