extends ColorRect

const EFFECT_TIME := 0.5

var _timer := Timer.new()
var _color := Color.BLACK

func push_color(pushed_color: Color) -> void:
	_color = pushed_color
	_timer.wait_time = EFFECT_TIME
	_timer.start()

func _ready():
	add_child(_timer)
	_timer.one_shot = true

func _process(_delta):
	if !_timer.is_stopped():
		var progress = 1.0 - (_timer.time_left / EFFECT_TIME)
		if progress < 0.5:
			color = GameVariables.fixColor(_color * (progress * 0.8))
		else:
			color = GameVariables.fixColor(_color * ((1.0 - progress) * 0.8))
