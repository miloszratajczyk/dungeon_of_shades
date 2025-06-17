extends Area2D

var health_color := Color.WHITE

@onready var view: Sprite2D = get_node("View")
@onready var game := get_node("../..")

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Engine.time_scale = 0
		DialogVariables.spawn_dialog("the-end")
