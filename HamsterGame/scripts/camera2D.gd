extends Camera2D

const DEAD_ZONE = 10  # Radio de la zona muerta centrada en el personaje
const MAX_DISTANCE = 145  # Distancia máxima que la cámara puede estar lejos del personaje
@export var objeto_a_seguir: Node2D  # El personaje que la cámara sigue por defecto
var clic_derecho_presionado = false  # Estado del clic derecho

func _process(delta: float) -> void:
	if clic_derecho_presionado:
		# Calcula la dirección del cursor con respecto al personaje
		var posicion_cursor = get_global_mouse_position()
		var direccion_cursor = posicion_cursor - objeto_a_seguir.global_position

		if direccion_cursor.length() > DEAD_ZONE:
			# Si el cursor está fuera de la zona muerta, calcula la nueva posición de la cámara
			position = objeto_a_seguir.global_position + direccion_cursor.normalized() * (direccion_cursor.length() - DEAD_ZONE)

			#Limita la cámara a la distancia máxima,
			var distancia_camara = position - objeto_a_seguir.global_position
			if distancia_camara.length() > MAX_DISTANCE:
				position = objeto_a_seguir.global_position + distancia_camara.normalized() * MAX_DISTANCE
		else:
			# Si el cursor está dentro de la zona muerta, no muevas la cámara
			position = objeto_a_seguir.global_position
	else:
		# Sigue al personaje normalmente
		position = objeto_a_seguir.position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		clic_derecho_presionado = event.pressed  # Actualiza el estado del clic derecho
