extends HBoxContainer

@export var label_rank : Label
@export var label_name : Label
@export var label_coins : Label
@export var label_time : Label

func set_data(rank: int, name: String, coins: int, best_time: float):
	label_rank.text = str(rank)
	label_name.text = name
	label_coins.text = str(coins)
	label_time.text = "%.2f" % best_time
