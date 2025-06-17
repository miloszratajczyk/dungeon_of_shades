extends Node
#class_name MapGenerator

enum TileType {EMPTY}

var rng := RandomNumberGenerator.new()

const MAP_MARGIN := 20
const START_ROOM_SIZE := 4
const MIN_ROOM_SIZE := 3
const MAX_ROOM_SIZE := 12

var map_max_x := 0
var map_max_y := 0

func _ready():
	rng.randomize()

var map: Array[Vector2i] = []

func digRoom(min_x: int, min_y: int, max_x: int, max_y: int):
	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			map.append(Vector2i(x, y))
	map_max_x = maxi(map_max_x, max_x)
	map_max_y = maxi(map_max_y, max_y)
	
func digPassage(point_a: Vector2i, point_b: Vector2i):
	for x in range(mini(point_a.x, point_b.x), maxi(point_a.x, point_b.x) + 1):
		map.append(Vector2i(x, point_a.y))
	for y in range(mini(point_a.y, point_b.y), maxi(point_a.y, point_b.y) + 1):
		map.append(Vector2i(point_b.x, y))

func generate(tile_map: TileMap) -> Array[Vector2i]:
	var room_count = 16
	map_max_x = 0
	map_max_y = 0
	map = []
	
	# dig start room
	digRoom(0, 0, START_ROOM_SIZE, START_ROOM_SIZE)
	
	var room_size: Vector2i
	var room_pos: Vector2i
	var second_to_last_door: Vector2i
	var last_door: Vector2i = Vector2i(START_ROOM_SIZE - 1, START_ROOM_SIZE - 1)
	var current_door: Vector2i
	
	for room_ix in range(room_count):
		room_size = Vector2i(rng.randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE),
			rng.randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE))
		
		if room_ix % 2 == 0:
			room_pos = Vector2i(map_max_x + 2, rng.randi_range(1, map_max_y))
		else:
			room_pos = Vector2i(rng.randi_range(1, map_max_x), map_max_y + 2)
		
		digRoom(room_pos.x, room_pos.y, room_pos.x + room_size.x, room_pos.y + room_size.y)
		
		current_door = Vector2i(
			room_pos.x + rng.randi_range(1, room_size.x - 1),
			room_pos.y + rng.randi_range(1, room_size.y - 1))
		digPassage(last_door, current_door)
		if room_ix > 1:
			digPassage(second_to_last_door, current_door)
			
		second_to_last_door = last_door
		last_door = current_door
	
	var vec_list: Array[Vector2i] = []
	
	# fill map with walls
	for x in range( - MAP_MARGIN, map_max_x + MAP_MARGIN):
		for y in range( - MAP_MARGIN, map_max_y + MAP_MARGIN):
			var vec = Vector2i(x, y)
			if map.has(vec):
				tile_map.set_cell(0, vec, 0, Vector2i(10, 1))
				
			else:
				vec_list.append(vec)
				
	tile_map.set_cells_terrain_connect(0, vec_list, 0, 0)
	
	return map
