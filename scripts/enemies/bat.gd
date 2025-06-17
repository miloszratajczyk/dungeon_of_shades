extends EnemyC

var _attack = preload ("res://scenes/attacks/bat_attack.tscn")

var _time: float
var _can_attack := false
	
func _process(delta) -> void:
	if _is_sleeping or destroyable.is_dying() or _is_sleeping:
		return

	# handle flipping
	var x_vel = velocity.x
	if x_vel < 0:
		view.flip_h = true
	elif x_vel > 0:
		view.flip_h = false
			
	# handle animation		
	_time += delta
	view.rotation = sin(_time * 8.0) * 0.32

func _physics_process(_delta: float) -> void:
	_handle_sleeping()
	if _is_sleeping or destroyable.is_dying() or _is_sleeping:
		return

	# handle movement
	if nav_agent.distance_to_target() > GameVariables.BAT_ATTACK_RADIUS:
		_can_attack = false
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * GameVariables.BAT_SPEED
	else:
		_can_attack = true
		velocity *= 0.95
	move_and_slide()

func _on_timer_timeout() -> void:
	super()
	if _can_attack:
		_spawn_attack()

func _spawn_attack():
	var instance := _attack.instantiate()
	instance.color = health_color
	add_child(instance)
	instance.look_at(player.global_position)
