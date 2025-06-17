extends Area2D

var health_color := Color.WHITE

@onready var view: Sprite2D = get_node("View")

func _ready():
	self.body_entered.connect(_on_body_entered)
	view.modulate = health_color

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		DialogVariables.spawn_dialog("cape-drop", true)
		PlayerVariables.add_cape(health_color)
		GameVariables.loot += 1
		queue_free()
