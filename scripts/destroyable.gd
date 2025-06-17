extends Node
class_name Destroyable

const DESTROY_TIME := 1.0

@onready var _parent: Node2D
var _timer := Timer.new()

func destroy() -> void:
	if _timer.is_stopped():
		_timer.start()
	
func is_dying() -> bool:
	return !_timer.is_stopped()

func _ready():
	_parent = get_parent()

	add_child(_timer)
	_timer.one_shot = true
	_timer.wait_time = DESTROY_TIME
	_timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	if is_dying():
		_parent.scale = Vector2(_timer.time_left / DESTROY_TIME, _timer.time_left / DESTROY_TIME)
		_parent.rotate(delta * 4)

func _on_timer_timeout() -> void:
	_parent.queue_free()
