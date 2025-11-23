extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var speed = 50


var facing = 1

func _physics_process(delta: float) -> void:
	
	velocity += get_gravity() * delta
	velocity.x = facing * speed
	
	# --- ANIMACIÓN
	$AnimatedSprite2D.play("enemy")
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	move_and_slide()

	# --- COLISION PAREDES Y PLAYER
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = - 100


# --- DETECTAR PLAYER ---
func _on_area_2d_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		speed = 150
		velocity.x = facing * speed  # refresco inmediato
func _on_area_2d_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		speed = 50
		velocity.x = facing * speed  # refresco inmediato


func _on_area_2d_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.recibir_daño(1)
