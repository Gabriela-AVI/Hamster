extends Node

const LOCAL_PLAYER_FILE := "user://player_data.json"
const SERVER_DATA_FILE := "user://players_data.json"

func load_all_players() -> Array:
	var local_player: Dictionary = _load_local_player()
	var server_players: Array = _load_server_players()

	var merged: Array = []

	if local_player.size() > 0:
		merged.append(local_player)

	for p in server_players:
		merged.append(p)

	return merged

func _load_local_player() -> Dictionary:
	if not FileAccess.file_exists(LOCAL_PLAYER_FILE):
		print("[LOAD] No local player file:", LOCAL_PLAYER_FILE)
		return {}

	var file := FileAccess.open(LOCAL_PLAYER_FILE, FileAccess.READ)
	if not file:
		return {}

	var txt: String = file.get_as_text()
	var parsed: Variant = JSON.parse_string(txt)

	if parsed is Dictionary:
		return parsed

	return {}

func _load_server_players() -> Array:
	if not FileAccess.file_exists(SERVER_DATA_FILE):
		return []

	var file := FileAccess.open(SERVER_DATA_FILE, FileAccess.READ)
	if not file:
		return []

	var txt: String = file.get_as_text()
	var parsed: Variant = JSON.parse_string(txt)

	if parsed is Array:
		return parsed

	return []

func send_player_to_server() -> void:
	var local: Dictionary = _load_local_player()
	if local.size() == 0:
		print("[ERROR] Can't send local player — file missing or invalid")
		return

	ServerSync.send_player_stats(local)

func fetch_all_players_from_server(target: Object = null, method_name: String = "") -> void:
	var local: Dictionary = _load_local_player()
	if local.size() == 0:
		print("[ERROR] Can't fetch server players — missing local player id")
		return

	if not local.has("id"):
		print("[ERROR] Local player has no id field")
		return

	var player_id: String = str(local["id"])
	ServerSync.fetch_player_data(player_id, target, method_name)
