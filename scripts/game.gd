extends Node2D

@onready var tile_map: TileMap = get_node("Map")
@onready var player := get_node("Player")
@onready var cat := get_node("Cat")
@onready var nav_region: NavigationRegion2D = get_node("NavigationRegion2D")
@onready var attacks_manager := get_node("AttacksManager")
@onready var enemies_manager := get_node("EnemiesManager")
@onready var loading_view := get_node("Player/Mess")

func _ready():
	DialogVariables.mess = get_node("Player/Mess")
	next_level()

func next_level():
	GameVariables.current_level += 1
	DialogVariables.spawn("loading")

	await get_tree().create_timer(0.1).timeout
	call_deferred("_generate")

	DialogVariables.spawn_dialog("level" + str(GameVariables.current_level))
	
func end():
	print("ENd game")
	
func _generate():
	attacks_manager.clear()
	enemies_manager.clear()
	tile_map.clear()
	
	player.global_position = Vector2(0.0, 0.0)
	cat.global_position = Vector2(16.0, 16.0)
	
	var tiles = MapGenerator.generate(tile_map)
	nav_region.bake_navigation_polygon()
	
	enemies_manager.spawn(tiles)

var _is_paused := false

func _pause():
	_is_paused = true
	DialogVariables.spawn("pause")
	Engine.time_scale = 0
	
func _unpause():
	_is_paused = false
	Engine.time_scale = 1
	
func _input(event):
	if event.is_action_pressed("pause"):
		if _is_paused:
			_unpause()
		else:
			_pause()
