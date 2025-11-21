extends Control

@export var entry_prefab: PackedScene
@export var list_container: VBoxContainer
@export var sync_button: Button

func _ready() -> void:
	sync_button.pressed.connect(_on_sync_pressed)
	update_leaderboard()


func update_leaderboard() -> void:
	for child in list_container.get_children():
		child.queue_free()

	var players: Array = PlayersLoader.load_all_players() as Array
	var total_stats: Array = []

	for p_variant in players:
		var p: Dictionary = p_variant as Dictionary

		var name: String = str(p.get("name", "???"))
		var levels: Array = p.get("levels", []) as Array

		var total_coins: int = 0
		var total_time: float = 0.0

		for lvl_variant in levels:
			var lvl: Dictionary = lvl_variant as Dictionary
			total_coins += int(lvl.get("coins", 0))
			total_time += float(lvl.get("best_time", 0.0))

		total_stats.append({
			"name": name,
			"coins": total_coins,
			"time": total_time
		})

	total_stats = _sort_stats(total_stats)

	var rank: int = 1
	for s in total_stats:
		var entry: Node = entry_prefab.instantiate()
		entry.set_data(rank, s["name"], s["coins"], s["time"])
		list_container.add_child(entry)
		rank += 1


func _sort_stats(arr: Array) -> Array:
	var tuples: Array = []
	for item in arr:
		var coins: int = -int(item.get("coins", 0))
		var time: float = float(item.get("time", 0.0))
		tuples.append([coins, time, item])
	tuples.sort()
	var out: Array = []
	for t in tuples:
		out.append(t[2])
	return out


func _on_sync_pressed() -> void:
	PlayersLoader.send_player_to_server()
	PlayersLoader.fetch_all_players_from_server(self, "_on_players_fetched")


func _on_players_fetched() -> void:
	update_leaderboard()
