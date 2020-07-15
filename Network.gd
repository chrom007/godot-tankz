extends Node

signal player_joined;

var players = {};
var online = false;
var is_server = false;
var peer : NetworkedMultiplayerENet = null;

func server_start():
	peer = NetworkedMultiplayerENet.new();
	var error = peer.create_server(6464, 10);

	if (error != OK):
		print("Server start error");
		peer = null;
		return false;

	is_server = true;
	online = true;
	get_tree().set_network_peer(peer);
	get_tree().connect("network_peer_connected", self, "_server_connected");
	get_tree().connect("network_peer_disconnected", self, "_server_disconnected");
	print("Server started");

func _server_connected(id):
	print("Player connected ", id);

func _server_disconnected(id):
	print("Player disconnected ", id);
	if (players.has(id)):
		players.erase(id);

remote func join_game(name):
	var id = get_tree().get_rpc_sender_id();
	players[id] = name;
	rpc("player_joined", id, name);
	rpc_id(id, "player_list", players);
	emit_signal("player_joined", id, name);
	print("Joining ", name);




func client_start(ip):
	if (ip == ""): ip = "127.0.0.1";
	peer = NetworkedMultiplayerENet.new();
	var error = peer.create_client(ip, 6464);

	if (error != OK):
		print("Client start error");
		peer = null;
		return false;

	is_server = false;
	online = true;
	get_tree().set_network_peer(peer);
	get_tree().connect("connected_to_server", self, "_client_connected");
	get_tree().connect("connection_failed", self, "_client_failed");
	get_tree().connect("server_disconnected", self, "_client_disconnected");
	print("Server started");

func _client_connected():
	print("Success connected");
	var name = "Player_" + str(round(rand_range(10000, 99999)));
	rpc("join_game", name);

func _client_failed():
	print("Failed connected");
	peer = null;
	online = false;

func _client_disconnected():
	print("Disconnected from server");
	peer = null;

puppet func player_joined(id, name):
	if (id != get_tree().get_network_unique_id()):
		players[id] = name;
		emit_signal("player_joined", id, name);
		print("Joining ", name);

func leave():
	get_tree()

puppet func player_list(_players):
	players = _players;
	print("Players list: ", players);
	get_tree().change_scene("res://Scenes/World.tscn");
