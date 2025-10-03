extends Node

var score: int = 0
var combo: int = 0
var last_score: int = 0
var max_combo: int = 0

func _ready():
	Signals.IncrementScore.connect(_on_increment_score)
	Signals.ResetCombo.connect(_on_reset_combo)
	Signals.IncrementCombo.connect(_on_increment_combo)

func _on_increment_score(points: int):
	score += points

func _on_reset_combo():
	combo = 0

func _on_increment_combo():
	combo += 1
	if combo > max_combo:
		max_combo = combo

func reset():
	score = 0
	combo = 0
	max_combo = 0
