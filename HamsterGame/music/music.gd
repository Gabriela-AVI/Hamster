extends AudioStreamPlayer


func _ready() -> void:
	volume_db = percent_to_db(SettingsData.music_volume)

func percent_to_db(percent: float) -> float:
	if percent <= 0:
		return -80.0
	return lerp(-60.0, 0.0, percent / 100.0)
