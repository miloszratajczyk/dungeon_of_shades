extends Area2D
class_name StickmanAttack

const ATTACK_TIME := 0.6
const DAMAGE_FACTOR := 0.16

var _timer := Timer.new()
var color: Color

@onready var view: Sprite2D = $View

func _ready():
	self.body_entered.connect(_on_body_entered)
	
	view.modulate = color

	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = ATTACK_TIME
	_timer.start()

func _process(_delta):
	var progress = 1- ( _timer.time_left/ ATTACK_TIME)
	if progress < 0.5:
		scale = Vector2 (progress * 2,progress * 2)
	elif progress < 1:
		scale = Vector2((1 - progress) * 2,(1 - progress) * 2)

	#rotate(delta * 4)

func _on_timer_timeout() -> void:
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(color * DAMAGE_FACTOR)
