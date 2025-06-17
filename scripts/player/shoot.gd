extends Node2D

enum State {IDLE, COOLDOWN}

signal shoot(position, direction)
signal cast(position)

var _state := State.IDLE
var _timer := Timer.new()
var _cashed_direction := Vector2(100, 0)
@onready var _parent := get_parent()

func is_shooting():
	return Input.is_action_pressed("shoot_primary_mouse") or Input.is_action_pressed("shoot_primary_joypad")

func _ready():
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)

func _physics_process(_delta):
	var parent_position = _parent.position

	if Input.is_action_just_pressed("shoot_secondary"):
		PlayerVariables.use_wand_cast()
		cast.emit(parent_position)
		
	if _state == State.IDLE:
		var direction := Vector2(100, 10)
		if Input.is_action_pressed("shoot_primary_mouse"):
			direction = get_global_mouse_position() - parent_position;
		elif Input.is_action_pressed("shoot_primary_joypad"):
			direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		else:
			return
			
		if direction == Vector2.ZERO:
			direction = _cashed_direction
		else:
			direction = direction.normalized()
			_cashed_direction = direction
		
		PlayerVariables.use_wand_bullet()
		shoot.emit(parent_position, direction)
		
		_state = State.COOLDOWN
		_timer.wait_time = GameVariables.PLAYER_BULLET_COOLDOWN_TIME
		_timer.start()

func _on_timer_timeout() -> void:
	if _state == State.COOLDOWN:
		_state = State.IDLE
