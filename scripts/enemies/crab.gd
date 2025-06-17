extends EnemyC

var _time: float
	
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
	view.rotation = sin(_time * 4) * 0.5

func _physics_process(_delta: float) -> void:
	_handle_sleeping()
	if _is_sleeping or destroyable.is_dying() or _is_sleeping:
		return
	
	# handle movement
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * GameVariables.CRAB_SPEED
	move_and_slide()
	
	# handle collisions
	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body is Player:
			body.damage(health_color * GameVariables.CRAB_DAMAGE_FACTOR)
