extends CharacterBody2D

const SPEED = 75.0

enum State { IR_A, IR_B, PERSEGUIR, SAFE }
var state = null

var objetivo_a: Vector2
var objetivo_b: Vector2

var detectado = false
var personaje: Node2D = null

var atacando = false

func _ready():
	# El enemigo toma su posición inicial:
	# A = 130px a la izquierda
	# B = 125px arriba desde A
	objetivo_a = global_position + Vector2(-130, 0)
	objetivo_b = objetivo_a + Vector2(0, -125)


func _physics_process(delta: float) -> void:
	match state:

		# --- PRIMER MOVIMIENTO: 130px IZQUIERDA ---
		State.IR_A:
			ir_a_posicion(objetivo_a)
			$AnimatedSprite2D.play("fly")
			$AnimatedSprite2D.flip_h = true   # mira a la izquierda

			if cerca_de(objetivo_a):
				state = State.IR_B

		# --- SEGUNDO MOVIMIENTO: 125px ARRIBA ---
		State.IR_B:
			ir_a_posicion(objetivo_b)
			$AnimatedSprite2D.play("fly")
			$AnimatedSprite2D.flip_h = false
			
			if cerca_de(objetivo_b):
				state = State.PERSEGUIR

		# --- PERSEGUIR COMO TÚ YA LO TENÍAS ---
		State.PERSEGUIR:
			if detectado and personaje:
				
				if (atacando):
					$AnimatedSprite2D.play("attack")
				
				else:
					var direction_x = sign(personaje.position.x - position.x)
					var direction_y = sign(personaje.position.y - position.y)

					velocity.x = direction_x * SPEED
					velocity.y = direction_y * SPEED

					$AnimatedSprite2D.play("fly")

					if direction_x == 0:
						velocity.x = 0
						velocity.y = 0
					else:
						$AnimatedSprite2D.flip_h = direction_x < 0

			else:
				velocity.x = 0
				$AnimatedSprite2D.play("idle")
				
		State.SAFE:
			velocity.x = 0
			velocity.y = 0
			


	move_and_slide()



# -----------------------------
# FUNCIONES AUXILIARES
# -----------------------------

func ir_a_posicion(target: Vector2):
	var direction = (target - global_position).normalized()
	velocity = direction * SPEED


func cerca_de(target: Vector2) -> bool:
	return global_position.distance_to(target) < 8



# DETECCIÓN DEL JUGADOR
func _on_area_2d_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		detectado = true
		personaje = body

		if state == null:
			state = State.IR_A
		
		if state == State.SAFE:
			state = State.PERSEGUIR

# --- ATACAR --
func _on_area_2d_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.recibir_daño(1)
		atacando = true


func _on_animated_sprite_2d_animation_finished() -> void:
	atacando = false


func _on_area_2d_safe_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state = State.SAFE
