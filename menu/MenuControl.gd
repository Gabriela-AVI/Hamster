extends Control

@onready var main_panel     = $MainPanel
@onready var levels_panel   = $LevelsPanel
@onready var stats_panel    = $StatsPanel
@onready var settings_panel = $SettingsPanel
@onready var name_label     = $UserNamePanel/UserNameLabel

@onready var name_input = $SettingsPanel/VBoxContainer/HBoxContainer/NameInput
@onready var fullscreen_button = $SettingsPanel/VBoxContainer/HBoxContainer2/FullscreenButton
var toggle_panels: Array[Control]

func _ready():
	toggle_panels = [
		main_panel,
		levels_panel,
		stats_panel,
		settings_panel
	]

	_show_only(main_panel)

	$MainPanel/PlayButton.pressed.connect(_on_play_pressed)
	$MainPanel/StatsButton.pressed.connect(_on_stats_pressed)
	$MainPanel/SettingsButton.pressed.connect(_on_settings_pressed)
	$MainPanel/ExitButton.pressed.connect(_on_exit_pressed)

	$LevelsPanel/Panel/BackButton.pressed.connect(_on_back_pressed)
	$StatsPanel/Panel/BackButton.pressed.connect(_on_back_pressed)
	$SettingsPanel/Panel/BackButton.pressed.connect(_on_back_pressed)
	$SettingsPanel/VBoxContainer/HBoxContainer/Apply.pressed.connect(_on_apply_name_pressed)
	
	$LevelsPanel/VBoxContainer/ButtonLvl1.pressed.connect(_on_lvl1_pressed)
	$LevelsPanel/VBoxContainer/ButtonLvl2.pressed.connect(_on_lvl1_pressed)
	
	fullscreen_button.pressed.connect(_on_fullscreen_toggled)
	_update_fullscreen_text()

	name_label.text = PlayerData.player_name

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_show_only(main_panel)

func _show_only(panel: Control) -> void:
	for p in toggle_panels:
		p.visible = (p == panel)

func _on_play_pressed():
	_show_only(levels_panel)

func _on_stats_pressed():
	_show_only(stats_panel)

func _on_settings_pressed():
	_show_only(settings_panel)

func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	_show_only(main_panel)

func _on_apply_name_pressed():
	var new_name = name_input.text.strip_edges()

	if new_name.is_empty():
		return

	PlayerData.player_name = new_name
	PlayerData.save_data()

	name_label.text = new_name

	print("Name changed to:", new_name)


func _on_lvl1_pressed():
	get_tree().change_scene_to_file("res://Level1.tscn")

func _on_lvl2_pressed():
	get_tree().change_scene_to_file("res://Level2.tscn")
	
func _on_fullscreen_toggled():

	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	_update_fullscreen_text()


func _update_fullscreen_text():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		fullscreen_button.text = "ON"
	else:
		fullscreen_button.text = "OFF"
