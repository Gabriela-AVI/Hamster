extends Sprite2D

@export var speed: float = 50.0  # пиксели в секунду

var region_offset: Vector2 = Vector2.ZERO

func _process(delta):
	# Сдвигаем region по X
	region_offset.x += speed * delta
	
	# Зацикливание по ширине региона, чтобы не ушло слишком далеко
	region_offset.x = fmod(region_offset.x, region_rect.size.x)
	
	# Применяем сдвиг к region
	region_rect.position = region_offset
