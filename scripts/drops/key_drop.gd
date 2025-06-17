extends Area2D

var health_color := Color.WHITE

@onready var view: Sprite2D = get_node("View")

func _ready():
	self.body_entered.connect(_on_body_entered)
	view.modulate = health_color

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		DialogVariables.spawn_single("key")
		GameVariables.has_key = true
		queue_free()
