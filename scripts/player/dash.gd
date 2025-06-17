extends Node

enum State {IDLE, DASHING, COOLDOWN}

@onready var _parent: CharacterBody2D = get_parent()
var _state := State.IDLE
var _timer := Timer.new()

func is_dashing():
	return _state == State.DASHING

func _ready():
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)

func _physics_process(_delta):
	if _state == State.IDLE and Input.is_action_pressed("move_dash") and _parent.velocity != Vector2.ZERO:
		_state = State.DASHING
		_timer.wait_time = GameVariables.PLAYER_DASH_TIME
		_timer.start()

func _on_timer_timeout() -> void:
	if _state == State.DASHING:
		_state = State.COOLDOWN
		_timer.wait_time = GameVariables.PLAYER_DASH_COOLDOWN_TIME
		_timer.start()
	elif _state == State.COOLDOWN:
		_state = State.IDLE
