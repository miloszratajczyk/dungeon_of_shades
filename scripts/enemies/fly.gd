extends EnemyC

var _attack = preload ("res://scenes/attacks/fly_bullet.tscn")

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
	if abs(velocity.x) > 1:
		view.position.y = sin(_time * 24)

func _physics_process(_delta: float) -> void:
	_handle_sleeping()
	if _is_sleeping or destroyable.is_dying() or _is_sleeping:
		return

	# handle movement
	if nav_agent.distance_to_target() > GameVariables.FLY_ATTACK_RADIUS:
		_can_attack = false
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * GameVariables.FLY_SPEED
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
	instance.health_color = health_color
	get_parent().add_child(instance)
	instance.position = position
	instance.direction = (player.global_position - global_position).normalized()
	instance.look_at(player.global_position)
