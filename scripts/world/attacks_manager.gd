extends Node2D

var player_bullet = preload ("res://scenes/attacks/player_bullet.tscn")
var player_cast = preload ("res://scenes/attacks/player_cast.tscn")

func clear():
	for child in get_children():
		child.queue_free()

func _ready():
	var player_shoot = get_node("../Player/Shoot")
	player_shoot.shoot.connect(_spawn_player_bullet)
	player_shoot.cast.connect(_spawn_player_cast)

func _spawn_player_bullet(starting_position: Vector2, direction: Vector2):
	var instance = player_bullet.instantiate()
	instance.position = starting_position
	instance.direction = direction
	add_child(instance)

func _spawn_player_cast(starting_position: Vector2):
	var instance = player_cast.instantiate()
	instance.position = starting_position
	add_child(instance)
