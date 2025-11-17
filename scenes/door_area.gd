extends Area2D

# Arrastra tu TileMapLayer aquí desde el editor (Inspector)
@export var tilemap: TileMapLayer

var player_en_rango = false

# Posición EXACTA del tile de la puerta (coordenada de tile, no píxeles)
var puerta_pos: Vector2i = Vector2i(94, 4)

# Coordenadas dentro del atlas
var puerta_cerrada: Vector2i = Vector2i(5, 6)
var puerta_abierta: Vector2i = Vector2i(1, 6)

# ID del source del tileset
var source_id: int = 0


func _ready():
	if tilemap == null:
		push_error("ERROR: No encuentro TileMapLayer.")
	else:
		print("TileMapLayer asignado:", tilemap)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_en_rango = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_en_rango = false

#
func abrir_puerta():
	tilemap.set_cell(
		puerta_pos,     # coordenada del tile
		source_id,      # ID del tileset
		puerta_abierta  # atlas coords del tile
	)

	print(" Puerta abierta!")
