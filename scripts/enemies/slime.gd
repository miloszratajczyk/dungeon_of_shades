extends EnemyC

var _is_dashing := false

func _ready():
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = GameVariables.SLIME_DASH_COOLDOWN_TIME
	_timer.start()
	
	view.modulate = health_color
	
func _process(_delta) -> void:
	if _is_sleeping or destroyable.is_dying() or _is_sleeping:
		return

	# handle flipping
	var x_vel = velocity.x
	if x_vel < 0:
			view.flip_h = true
	elif x_vel > 0:
			view.flip_h = false
			
	# handle animation		
	if _is_dashing:
		view.scale.y = 0.75
	else:
		view.scale.y = 1.0

func _physics_process(_delta: float) -> void:
	_handle_sleeping()
	if _is_sleeping or destroyable.is_dying() or _is_sleeping:
		return
	
	# handle movement
	if _is_dashing:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * GameVariables.SLIME_SPEED
	else:
		velocity *= 0.95
	move_and_slide()
	
	# handle collisions
	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body is Player:
			body.damage(health_color * GameVariables.SLIME_OFFENSE_DAMAGE_FACTOR)
			self.damage(health_color * GameVariables.SLIME_DEFENSE_DAMAGE_FACTOR)

func _on_timer_timeout() -> void:
	if _is_dashing:
		_timer.wait_time = GameVariables.SLIME_DASH_COOLDOWN_TIME
		_timer.start()
	else:
		nav_agent.target_position = player.global_position
		_timer.wait_time = GameVariables.SLIME_DASH_TIME
		_timer.start()
	_is_dashing = !_is_dashing
