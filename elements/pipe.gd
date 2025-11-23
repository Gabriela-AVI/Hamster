extends Area2D

signal collected

func _ready():
	$AnimatedSprite2D.play("pipe") # Animacion
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"): 
		body.recoger_moneda()       # Llamar método del jugador
		emit_signal("collected", body)
		queue_free()                # Eliminar moneda
