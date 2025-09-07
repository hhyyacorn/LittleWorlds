extends Sprite2D

@onready var falling_key = preload("res://objects/falling_key.tscn")
@onready var score_text = preload("res://objects/score_press_text.tscn")
@export var key_name: String = ""



var falling_key_queue = []

var perfect_press_threshold: float = 30
var great_press_threshold: float = 50
var good_press_threshold: float = 60
var ok_press_threshold: float = 80

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20

func _ready():
	Signals.CreateFallingKey.connect(CreateFallingKey)

func _process(delta):
	
	if falling_key_queue.size() > 0:
		
		for fk in falling_key_queue.duplicate():
			if not is_instance_valid(fk):
				falling_key_queue.erase(fk)
				continue
			
			if fk.has_passed:
				falling_key_queue.erase(fk)
				
				var st_inst = score_text.instantiate()
				add_child(st_inst)
				st_inst.SetTextInfo("MISS")
				st_inst.global_position = global_position + Vector2(-38,-25)
				Signals.ResetCombo.emit()
				
				fk.call_deferred("queue_free")
			
		if Input.is_action_just_pressed(key_name):
			var closest_key = null
			var closest_distance = INF
			
			for fk in falling_key_queue:
				var dist = abs(fk.pass_threshold - fk.global_position.y)
				if dist < closest_distance:
					closest_distance = dist
					closest_key = fk
	
			if closest_key:
				falling_key_queue.erase(closest_key)
			
				var press_score_text: String = ""
				if closest_distance < perfect_press_threshold:
					Signals.IncrementScore.emit(perfect_press_score)
					press_score_text = "PERFECT"
					Signals.IncrementCombo.emit()
				elif closest_distance < great_press_threshold:
					Signals.IncrementScore.emit(great_press_score)
					press_score_text = "GREAT"
					Signals.IncrementCombo.emit()
				elif closest_distance < good_press_threshold:
					Signals.IncrementScore.emit(good_press_score)
					press_score_text = "GOOD"
					Signals.IncrementCombo.emit()
				elif closest_distance < ok_press_threshold:
					Signals.IncrementScore.emit(ok_press_score)
					press_score_text = "OK"
					Signals.IncrementCombo.emit()
				else:
					press_score_text = "MISS"
					Signals.ResetCombo.emit()
					pass
				
				closest_key.queue_free()
				
				var st_inst = score_text.instantiate()
				add_child(st_inst)
				st_inst.SetTextInfo(press_score_text)
				st_inst.global_position = global_position + Vector2(-38,-25)

func CreateFallingKey(button_name: String):
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		add_child(fk_inst)
		fk_inst.Setup(position.x, frame + 4) 
		falling_key_queue.push_back(fk_inst)


func _on_random_spawn_timer_timeout():
	#CreateFallingKey()
	$RandomSpawnTimer.wait_time = randf_range(0.7,3)
	$RandomSpawnTimer.start()
