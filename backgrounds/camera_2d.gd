extends Camera2D

@export var scroll_speed: float = 100.0  # pixels per second

func _process(delta: float) -> void:
	position.x += scroll_speed * delta
