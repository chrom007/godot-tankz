extends Node

var players = {};
var connected = false;
var is_server = false;
var peer = null;

func server_start():
	peer = NetworkedMultiplayerENet.new();
	var error = peer.create_server(6464, 10);

	if (error != OK):
		print("Server start error");
		peer = null;

	get_tree().set_network_peer(peer);
	get_tree().connect("network_peer_connected", self, "_server_connected");
	get_tree().connect("network_peer_disconnected", self, "_server_disconnected")
	print("Server started");

func _server_connected(id):
	print("Player connected ", id);

func _server_disconnected(id):
	print("Player disconnected ", id);





func client_start():
	peer = NetworkedMultiplayerENet.new();
	var error = peer.create_client("192.168.1.10", 6464);

	if (error != OK):
		print("Client start error");
		peer = null;

	get_tree().set_network_peer(peer);
	get_tree().connect("connected_to_server", self, "_client_connected");
	get_tree().connect("connection_failed", self, "_client_failed");
	get_tree().connect("server_disconnected", self, "_client_disconnected");
	print("Server started");

func _client_connected():
	print("Success connected");

func _client_failed():
	print("Failed connected");
	peer = null;

func _client_disconnected():
	print("Disconnected from server");
	peer = null;
