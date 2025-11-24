extends Node

var music_volume := 50
var fullscreen := false

var save_path := "user://settings.cfg"

func save():
	var config = ConfigFile.new()
	config.set_value("general", "music_volume", music_volume)
	config.set_value("general", "fullscreen", fullscreen)
	config.save(save_path)

func load():
	var config = ConfigFile.new()
	var err = config.load(save_path)
	if err != OK:
		return

	music_volume = config.get_value("general", "music_volume", 50)
	fullscreen = config.get_value("general", "fullscreen", false)
