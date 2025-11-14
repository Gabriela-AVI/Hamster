extends CharacterBody2D

signal curar_personaje()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var tiempo_quieto = 0
var monedas = 0

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# SALTO (jump)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#  MOVIMIENTO HORIZONTAL 
	var direction := 0.0
	
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1

	# ANIMACIONES 
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")

		# Voltear hámster si va a la izquierda
		$AnimatedSprite2D.flip_h = direction < 0
		
		tiempo_quieto = 0
	else:
		tiempo_quieto += delta

		if tiempo_quieto > 4:
			$AnimatedSprite2D.play("stop")
		else:
			$AnimatedSprite2D.play("idle")

		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func recoger_moneda():
	monedas += 1
	print("DEBUG → Monedas recogidas: ", monedas)




# --- FUNCIÓN CURA ---
func curar():
	curar_personaje.emit()
	
	
