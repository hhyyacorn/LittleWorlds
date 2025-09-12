extends Sprite2D

@export var fall_speed: float = 2.0

var init_y_pos: float = -800

#true is fk passes kl
var has_passed: bool = false
var pass_threshold = 620

func _init():
	set_process(false)

func _process(_delta):
	global_position += Vector2(0, fall_speed)
	
	#Used to find how long it takes for fish to reach fish (1.533)
	if global_position.y > pass_threshold and not has_passed:
		has_passed = true
		

func Setup(target_x: float, target_frame: int):
	global_position = Vector2(target_x, init_y_pos)
	frame = target_frame
	
	set_process(true)


func _on_destroy_timer_timeout():
	queue_free()
