extends CharacterBody2D

signal curar_personaje()

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

# DASH
const DASH_SPEED = 250.0 #velocidad dash
const DASH_TIME = 0.3
const DASH_COOLDOWN = 0.4
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 0.0

# Otras variables
var tiempo_quieto = 0
var monedas = 0
var vida = 1

func _physics_process(delta: float) -> void:

	# --- TIMERS DEL DASH ---
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

		# Mantener animación de dash
		$AnimatedSprite2D.play("dash")

		velocity.x = dash_direction * DASH_SPEED
		move_and_slide()
		return



	# --- GRAVEDAD ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- SALTO ---
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- MOVIMIENTO ---
	var direction := 0.0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1

	# --- DASH ---
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		start_dash(direction)
		return


	# --- ANIMACIONES ---
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
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


# --- FUNCIÓN DASH ---
func start_dash(direction):
	is_dashing = true
	dash_timer = DASH_TIME
	dash_cooldown_timer = DASH_COOLDOWN

	# Reproducir animación del dash
	$AnimatedSprite2D.play("dash")

	# Si no hay dirección, usar donde mira el sprite
	if direction == 0:
		dash_direction = -1 if $AnimatedSprite2D.flip_h else 1
	else:
		dash_direction = direction


# FUNCIÓN MORIR
func morir():
	print("DEBUG → El jugador ha muerto")

	# Dejar de mover
	velocity = Vector2.ZERO
	set_physics_process(false)

	# Reproducir animación de muerte
	$AnimatedSprite2D.play("die")

	# Esperar un poco y reiniciar escena
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()


# GANAR VIDA EXTRA
func ganar_vida(cantidad):
	vida += cantidad
	print("DEBUG → Vida actual: ", vida)


# RECOGER MONEDAS
func recoger_moneda():
	monedas += 1
	print("DEBUG → Monedas recogidas: ", monedas)


# FUNCIÓN PARA PINCHOS 
func _on_area_2d_body_entered(body: Node2D) -> void:
	vida -= 1
	print("DEBUG → Vida actual: ", vida)
	print("au")

	if vida <= 0:
		morir()


	# FUNCIÓN CURA
func curar():
	curar_personaje.emit()
