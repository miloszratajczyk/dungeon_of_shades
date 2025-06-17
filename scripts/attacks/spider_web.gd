extends Area2D

var _time_passed := 0.0
var health_color: Color

@onready var view: Sprite2D = $View
@onready var destroyable: = $Destroyable

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	
	view.modulate = health_color

func _process(delta):
	if _time_passed < 1.0:
		_time_passed += delta
		scale = Vector2(_time_passed, _time_passed)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(health_color * GameVariables.SPIDER_WEB_DAMAGE_FACTOR)
		body.debuff_speed()
	else:
		destroyable.destroy()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.damage(health_color * GameVariables.SPIDER_WEB_DAMAGE_FACTOR)
		body.buff_speed()
