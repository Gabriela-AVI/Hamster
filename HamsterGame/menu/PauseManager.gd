extends Node

@export var pause_menu: Control
@export var resume_button: Button
@export var retry_button: Button
@export var mainmenu_button: Button

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	mainmenu_button.pressed.connect(_on_mainmenu_pressed)

	pause_menu.visible = false
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	GameState.is_paused = !GameState.is_paused
	pause_menu.visible = GameState.is_paused

func _on_resume_pressed():
	GameState.is_paused = false
	pause_menu.visible = false

func _on_retry_pressed():
	GameState.is_paused = false
	get_tree().reload_current_scene()

func _on_mainmenu_pressed():
	GameState.is_paused = false
	get_tree().change_scene_to_file("res://menu/MainMenu.tscn")
