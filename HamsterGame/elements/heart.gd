extends Area2D

@export var cantidad_vida = 1

func _ready():
	$AnimatedSprite2D.play("heart") # Animacion
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.ganar_vida(cantidad_vida)  # Llama a la función del jugador
		queue_free() # desaparece
		
