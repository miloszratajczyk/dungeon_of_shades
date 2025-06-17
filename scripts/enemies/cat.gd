extends CharacterBody2D

const SPEED := 128.0
const REFRESH_TIME := 0.256
const DISTANCE_MARGIN := 128.0

@export var player: Player

@onready var nav_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var view: Sprite2D = get_node("View")

var _timer := Timer.new()
var _time: float

func _ready():
	add_child(_timer)
	_timer.one_shot = false
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = REFRESH_TIME
	_timer.start()
	
func _process(delta) -> void:

	# handle flipping
	var x_vel = velocity.x
	if x_vel < 0:
		view.flip_h = true
	elif x_vel > 0:
		view.flip_h = false
			
	# handle animation
	_time += delta
	if abs(velocity.x) > 1:
		view.position.y = sin(_time * 32) * 2

func _physics_process(_delta: float) -> void:

	# handle movement
	if nav_agent.distance_to_target() > DISTANCE_MARGIN:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * SPEED
	else:
		velocity *= 0.9

	move_and_slide()
	
	# handle collisions
	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body is Player:
			DialogVariables.spawn_single("cat-collison")

func _on_timer_timeout() -> void:
	nav_agent.target_position = player.global_position
