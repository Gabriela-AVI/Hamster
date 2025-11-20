extends CharacterBody2D

signal curar_personaje()

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

# DASH
const DASH_SPEED = 250.0
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

# Detectar interacción con la puerta
var puerta_area: Node = null



func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
		
	# --- TIMERS DEL DASH ---
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

		$AnimatedSprite2D.play("dash")
		velocity.x = dash_direction * DASH_SPEED
		# mover
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

	# --- USAR PUERTA (E) ---
	if Input.is_action_just_pressed("interact") and puerta_area != null:
		puerta_area.abrir_puerta()
		finalizar_nivel()
		$AnimatedSprite2D.play("run")
		
 # Reiniciar si cae al vacío ---
	if global_position.y > 600:
		$AnimatedSprite2D.play("die")
		get_tree().reload_current_scene()
		

# --- FUNCIÓN DASH ---
func start_dash(direction):
	is_dashing = true
	dash_timer = DASH_TIME
	dash_cooldown_timer = DASH_COOLDOWN

	$AnimatedSprite2D.play("dash")
	_push_bodies()

	if direction == 0:
		dash_direction = -1 if $AnimatedSprite2D.flip_h else 1
	else:
		dash_direction = direction
		
# -- EMPUJAR CAJA --
func _push_bodies():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_dir = collision.get_normal() * -1.0
			push_dir.y = 0
			var force = push_dir * DASH_SPEED / 1
			collider.apply_central_impulse(force)


# --- FUNCIÓN MORIR ---
func morir():
	print("DEBUG → El jugador ha muerto")
	velocity = Vector2.ZERO
	set_physics_process(false)
	$AnimatedSprite2D.play("die")

	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()


# --- GANAR VIDA ---
func ganar_vida(cantidad):
	vida += cantidad
	print("DEBUG → Vida actual: ", vida)


# --- RECOGER MONEDAS ---
func recoger_moneda():
	monedas += 1
	print("DEBUG → Monedas recogidas: ", monedas)


#--- DAÑO por pinchos---
func _on_area_2d_body_entered(body: Node2D) -> void:
	vida -= 1
	$AudioDamage.play()
	print("DEBUG → Vida actual: ", vida)
	if vida <= 0:
		morir()


# --- DAÑO por enemy
func recibir_daño(cantidad):
	if vida <= 0:
		return
	vida -= cantidad
	print("DEBUG → Vida actual: ", vida)
	
	$AudioDamage.play()

	if vida <= 0:
		morir()


# --- DETECTAR ENTRADA EN PUERTA ---
func _on_door_area_body_entered(body):
	if body == self:
		puerta_area = get_parent().get_node("DoorArea")

# --- DETECTAR SALIDA DE LA PUERTA ---
func _on_door_area_body_exited(body):
	if body == self:
		puerta_area = null


# --- CURAR ---
func curar():
	curar_personaje.emit()


# --- TERMINAR NIVEL ---
func finalizar_nivel():
	print("Nivel completado")
	await get_tree().create_timer(0.5).timeout
	# Cambia a tu siguiente escena:
	#get_tree().change_scene_to_file("res://next_level.tscn")
	get_tree().quit()  # Temporal si no tienes siguiente nivel
