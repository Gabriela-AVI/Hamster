extends Area2D

# Start the pipe's movement
func _ready() -> void:
	$AnimatedSprite2D.play("pipe")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
