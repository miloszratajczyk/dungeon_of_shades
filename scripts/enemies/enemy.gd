extends CharacterBody2D
class_name EnemyC

var player: Player
var _timer := Timer.new()
var _is_sleeping := true
var health_color := Color.WHITE

@onready var nav_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var destroyable := get_node("Destroyable")
@onready var view: Sprite2D = get_node("View")

func damage(color: Color) -> void:
	if _is_sleeping:
		_wake_up()
	
	health_color = GameVariables.fixColor(health_color - color)
	if GameVariables.shouldDie(health_color):
		destroyable.destroy()
	
	view.modulate = health_color

func _ready():
	add_child(_timer)
	_timer.one_shot = false
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = GameVariables.MOB_REFRESH_TIME
	_timer.start()
	
	view.modulate = health_color

func _wake_up():
	_is_sleeping = false
	view.rotation = 0

func _handle_sleeping() -> void:
	if _is_sleeping and nav_agent.distance_to_target() < GameVariables.MOB_WAKING_DISTANCE:
		_wake_up()

func _on_timer_timeout() -> void:
	nav_agent.target_position = player.global_position
