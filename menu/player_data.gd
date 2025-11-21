extends Node

const SAVE_PATH := "user://player_data.json"

var player_id := ""
var player_name := ""
var levels := []

func _ready():
	load_data()

func register_level(lvl_id: int):
	for lvl in levels:
		if lvl.lvl_id == lvl_id:
			return

	levels.append({
		"lvl_id": lvl_id,
		"best_time": null,
		"coins": 0,
		"attempts": 0
	})


func add_attempt(lvl_id: int):
	var lvl = _get_level(lvl_id)
	if lvl:
		lvl.attempts += 1
		save_data()


func update_level_result(lvl_id: int, new_coins: int, new_time: float):
	var lvl = _get_level(lvl_id)
	if not lvl:
		return

	var old_coins = lvl.coins
	var old_time = lvl.best_time

	if new_coins < old_coins:
		return

	if new_coins > old_coins:
		lvl.coins = new_coins
		lvl.best_time = new_time
		save_data()
		return

	if old_time == null or new_time < old_time:
		lvl.best_time = new_time
		save_data()


func _get_level(lvl_id: int):
	for lvl in levels:
		if lvl.lvl_id == lvl_id:
			return lvl
	return null

func save_data():
	var data = {
		"id": player_id,
		"name": player_name,
		"levels": levels
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var text = file.get_as_text()
		file.close()

		var result = JSON.parse_string(text)
		if result is Dictionary:
			player_id = result.get("id", "")
			player_name = result.get("name", "")
			levels = result.get("levels", [])
	else:
		_create_new_user()


func _create_new_user():
	player_id = _generate_id()
	player_name = "Player"
	levels = []
	save_data()


func _generate_id(length := 8) -> String:
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var rng = RandomNumberGenerator.new()
	var id := ""

	for i in length:
		id += chars[rng.randi_range(0, chars.length() - 1)]
	return id
