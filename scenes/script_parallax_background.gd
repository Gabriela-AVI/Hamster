extends ParallaxBackground



# Scroll's background
func _process(delta: float) -> void:
	var velocidad = 10
	scroll_offset.x -= velocidad * delta
