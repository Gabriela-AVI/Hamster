extends Node

const SERVER_UPLOAD_URL := "http://127.0.0.1:8000/upload_stats/"
const SERVER_LEADERBOARD_URL := "http://127.0.0.1:8000/leaderboard/?id="
const LOCAL_FILE := "user://players_data.json"

func send_player_stats(player_data: Dictionary) -> void:
	print("\n[SEND] Sending player data to server...")

	var http := HTTPRequest.new()
	add_child(http)

	http.request_completed.connect(_on_request_send_completed)

	var json_text := JSON.stringify(player_data)
	var headers := ["Content-Type: application/json"]

	http.request(
		SERVER_UPLOAD_URL,
		headers,
		HTTPClient.METHOD_POST,
		json_text
	)


func _on_request_send_completed(result, response_code, headers, body):
	print("[SEND] Response code:", response_code)
	print("[SEND] Body:", body.get_string_from_utf8())


func fetch_player_data(player_id: String, target: Object = null, method_name: String = "") -> void:
	print("\n[GET] Fetching leaderboard for:", player_id)

	var http := HTTPRequest.new()
	add_child(http)

	# Передаем callback
	http.request_completed.connect(func(result, response_code, headers, body):
		_on_request_get_completed(result, response_code, headers, body)
		if target and method_name != "":
			target.call_deferred(method_name)
	)

	var url := SERVER_LEADERBOARD_URL + player_id
	http.request(url)


func _on_request_get_completed(result, response_code, headers, body):
	print("[GET] Response code:", response_code)

	if response_code != 200:
		print("[GET] Error!")
		return

	var text: String = body.get_string_from_utf8()
	var parsed: Variant = JSON.parse_string(text)

	if parsed == null:
		print("[GET] JSON parse error!")
		return

	print("[GET] OK. Saving players_data.json...")
	save_players_file(parsed)

func save_players_file(data):
	var file := FileAccess.open(LOCAL_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	print("[SAVE] Saved:", LOCAL_FILE)
