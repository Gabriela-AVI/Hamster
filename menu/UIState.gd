extends Node
class_name UIState

@export var level_timer_label: Label
@export var coins_label: Label


func set_time_text(text: String) -> void:
	if level_timer_label:
		level_timer_label.text = text


func set_coins_text(value: int) -> void:
	if coins_label:
		coins_label.text = str(value)
