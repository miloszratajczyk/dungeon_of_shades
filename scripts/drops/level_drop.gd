extends Area2D

var health_color := Color.WHITE
var is_locked = true

@onready var view: Sprite2D = get_node("View")
@onready var game := get_node("../..")

var _level_drop_texture := preload("res://sprites/drops/level_drop.png")

func _ready():
	self.body_entered.connect(_on_body_entered)
	view.modulate = health_color

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_locked:
			if GameVariables.has_key:
				GameVariables.has_key = false
				view. texture = _level_drop_texture
				is_locked = false
			else:
				DialogVariables.spawn_single("lock")
		else:
			game.next_level()
