extends Node2D
class_name EnemiesManager

var rng := RandomNumberGenerator.new()

# enemies
var _ghost := preload ("res://scenes/enemies/ghost.tscn")
var _slime := preload ("res://scenes/enemies/slime.tscn")
var _crab := preload ("res://scenes/enemies/crab.tscn")
var _stickman := preload ("res://scenes/enemies/stickman.tscn")
var _bat := preload ("res://scenes/enemies/bat.tscn")
var _spider := preload ("res://scenes/enemies/spider.tscn")
var _fly := preload ("res://scenes/enemies/fly.tscn")

# drops
var _cape_drop := preload ("res://scenes/drops/cape_drop.tscn")
var _wand_drop := preload ("res://scenes/drops/wand_drop.tscn")
var _level_drop := preload ("res://scenes/drops/level_drop.tscn")
var _cake_drop := preload ("res://scenes/drops/cake_drop.tscn")
var _life_drop := preload ("res://scenes/drops/life_drop.tscn")
var _key_drop := preload ("res://scenes/drops/key_drop.tscn")

#  spawn_probability, enemy_scene, spawn_strength
var enemies_spawn_data := [
	# level 1 [10]
	[
		[0.006, _ghost, 0.32],
		[0.004, _slime, 0.24],
	],
	# level 2 [12]
	[
		[0.005, _ghost, 0.32],
		[0.005, _slime, 0.32],
		[0.002, _crab, 0.24],
	],
	# level 3 [14]
	[
		[0.004, _ghost, 0.50],
		[0.004, _slime, 0.32],
		[0.003, _crab, 0.32],
		[0.003, _stickman, 0.24],
	],
	# level 4 [16]
	[
		[0.002, _ghost, 0.5],
		[0.002, _slime, 0.5],
		[0.003, _crab, 0.5],
		[0.005, _stickman, 0.24],
		[0.003, _bat, 0.24],
	],
	# level 5 [18]
	[
		[0.005, _stickman, 0.5],
		[0.005, _bat, 0.5],
		[0.004, _spider, 0.24],
		[0.004, _fly, 0.24],
	],
	# level 6 [20]
	[
		[0.007, _stickman, 0.7],
		[0.001, _stickman, 0.8],
		[0.007, _bat, 0.7],
		[0.001, _bat, 0.8],
		[0.002, _crab, 0.3],
	],
	# level 7 [22]
	[
		[0.007, _spider, 0.7],
		[0.001, _spider, 0.6],
		[0.007, _fly, 0.7],
		[0.001, _fly, 0.8],
		[0.002, _slime, 0.3],
	],
	# level 8 [24]
	[
		[0.002, _ghost, 0.5],
		[0.002, _slime, 0.5],
		[0.002, _crab, 0.5],
		[0.002, _stickman, 0.5],
		[0.002, _bat, 0.5],
		[0.002, _spider, 0.5],
		[0.002, _fly, 0.5],
	],
]

#  spawn_count drop_scene, spawn_strength
var drop_spawn_data := [
	# level 1
	[
		[_cape_drop, 0.50],
	],
	# level 2
	[
		[_wand_drop, 0.30],
		[_wand_drop, 0.30],
	],
	# level 3
	[
		[_life_drop, 0.20],
		[_cape_drop, 0.30],
	],
	# level 4
	[
		[_life_drop, 0.25],
		[_cape_drop, 0.40],
		[_wand_drop, 0.40],
	],
	# level 5
	[
		[_life_drop, 0.30],
		[_cape_drop, 0.50],
		[_wand_drop, 0.50],
	],
	# level 6
	[
		[_life_drop, 0.35],
		[_cape_drop, 0.60],
		[_wand_drop, 0.60],
	],
	# level 7
	[
		[_life_drop, 0.40],
		[_cape_drop, 0.70],
		[_wand_drop, 0.70],
	],
	# level 8
	[
		[_life_drop, 0.50],
	],

]

@onready var _player: Player = get_node("../Player")

func clear():
	for child in get_children():
		child.queue_free()

func _ready():
	rng.randomize()

func spawn(tiles: Array[Vector2i]) -> void:
	var last_tile_ix = len(tiles) - 1
	if GameVariables.current_level == 8:
		_spawn_drop_item(tiles[last_tile_ix], _cake_drop, 1.0)
	else:
		_spawn_drop_item(tiles[last_tile_ix], _level_drop, 0.5)
	tiles.remove_at(last_tile_ix)
	
	if GameVariables.current_level != 8:
		var mid_tile_ix : = int(len(tiles) *0.5)
		_spawn_drop_item(tiles[mid_tile_ix], _key_drop, 0.64)
		tiles.remove_at(mid_tile_ix)
	
	for drop_item in drop_spawn_data[GameVariables.current_level - 1]:
		var drop_tile_ix = rng.randi_range(0, len(tiles))
		_spawn_drop_item(tiles[drop_tile_ix], drop_item[0], drop_item[1])
		tiles.remove_at(drop_tile_ix)

	for tile in tiles:
		# check if in start room
		if 0 <= tile.x and tile.x <= (2 * MapGenerator.START_ROOM_SIZE) \
		and 0 <= tile.y and tile.y <= (2 * MapGenerator.START_ROOM_SIZE):
			continue
		
		for i in enemies_spawn_data[GameVariables.current_level - 1]:
			if rng.randf() < i[0]:
				_spawn_enemy(tile, i[1], i[2])
				break

func _spawn_drop_item(item_position: Vector2i, item: PackedScene, strength: float):
	var instance = item.instantiate()
	instance.position = item_position * 16
	instance.health_color = GameVariables.randomColor(strength)
	add_child(instance)

func _spawn_enemy(enemy_position: Vector2i, enemy: PackedScene, strength: float):
	var instance = enemy.instantiate()
	instance.position = enemy_position * 16
	instance.player = _player
	instance.health_color = GameVariables.randomColor(strength)
	add_child(instance)
