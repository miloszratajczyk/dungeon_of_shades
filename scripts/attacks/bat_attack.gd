extends Area2D
class_name BatAttack

var _timer := Timer.new()
var color: Color
var _spin_offset := 1.0

@onready var view: Sprite2D = $View

func _ready():
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	_spin_offset = randf_range(3.0, 5.0)
	
	self.body_entered.connect(_on_body_entered)
	
	view.modulate = color

	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = GameVariables.BAT_ATTACK_TIME
	_timer.start()

func _process(delta):
	var progress = 1 - (_timer.time_left / GameVariables.BAT_ATTACK_TIME)
	if progress < 0.25:
		scale = Vector2(progress * 4, progress * 4)
	elif progress > 0.75:
		scale = Vector2((1 - progress) * 4, (1 - progress) * 4)

	#view.modulate = color
	rotate(delta * _spin_offset)

func _on_timer_timeout() -> void:
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(color * GameVariables.BAT_DAMAGE_FACTOR)
