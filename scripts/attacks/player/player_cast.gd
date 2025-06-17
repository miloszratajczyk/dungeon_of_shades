extends Area2D
class_name PlayerCast

var _timer := Timer.new()
var _first_player_collision := true
var _color: Color

@onready var view: Sprite2D = $View

func _ready():
	self.body_entered.connect(_on_body_entered)
	
	_color = PlayerVariables.wand_color
	view.modulate = _color

	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = GameVariables.PLAYER_CAST_TIME
	_timer.start()

func _process(delta):
	var time_passed = GameVariables.PLAYER_CAST_TIME - _timer.time_left
	if time_passed < 1.0:
		scale = Vector2(time_passed, time_passed)
	elif _timer.time_left < 1:
		scale = Vector2(_timer.time_left, _timer.time_left)

	rotate(delta * 4)

func _on_timer_timeout() -> void:
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if _first_player_collision and body is Player:
		_first_player_collision = false
		return
	if body.is_in_group("killable"):
		if body is Player:
			DialogVariables.spawn_single("cast-collison")
			body.damage(_color * (GameVariables.PLAYER_CAST_DAMAGE_FACTOR * 0.5))
		else:
			body.damage(_color * GameVariables.PLAYER_CAST_DAMAGE_FACTOR)
