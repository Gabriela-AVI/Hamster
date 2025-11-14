extends CharacterBody2D

signal curar_personaje()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#Contador 
var tiempo_quieto = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Inicio animaciones
# hamster en moviemnto
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		if direction < 0:
			$AnimatedSprite2D.flip_h = true # Animacion girada izquierda
		else:
			$AnimatedSprite2D.flip_h = false 
		
		tiempo_quieto = 0
# hamster parado
	else:
		tiempo_quieto += delta #contador
		
		if tiempo_quieto > 4:
			$AnimatedSprite2D.play("stop")
		else:
			$AnimatedSprite2D.play("idle")
		
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# FUNCION CURA 
func curar():
	curar_personaje.emit()
