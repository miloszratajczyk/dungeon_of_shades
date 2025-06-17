extends Node

var health_color: Color = Color(1, 1, 1, 1)
var capes: Array[Color] = []
var wands: Array[Color] = [Color(0.5, 0.5, 0.5, 1)]
var current_cape: int = 0
var current_wand: int = 0

var cape_changed := true
var wand_changed := true

var cape_color: Color:
	get:
		if len(capes) == 0:
			return health_color
		return capes[current_cape]
	set(value):
		if len(capes) != 0:
			capes[current_cape] = value
			cape_changed = true

var wand_color: Color:
	get:
		if len(wands) == 0:
			return Color.BLACK
		return wands[current_wand]
	set(value):
		if len(wands) != 0:
			wands[current_wand] = value
			wand_changed = true

func damage(color: Color) -> void:
	if len(capes) == 0:
		health_color -= color
	else:
		var cape_damage = color * cape_color
		cape_color -= cape_damage
		health_color -= color - cape_damage
		cape_color = GameVariables.fixColor(cape_color)
	health_color = GameVariables.fixColor(health_color)

	check_cape_color()
	check_health_color()

func use_wand_bullet():
	wand_color = GameVariables.fixColor(Color(\
	wand_color.r - GameVariables.WAND_BULLET_USE, \
	wand_color.g - GameVariables.WAND_BULLET_USE, \
	wand_color.b - GameVariables.WAND_BULLET_USE))
	check_wand_color()
	
func use_wand_cast():
	wand_color = GameVariables.fixColor(Color(\
	wand_color.r - GameVariables.WAND_CAST_USE, \
	wand_color.g - GameVariables.WAND_CAST_USE, \
	wand_color.b - GameVariables.WAND_CAST_USE))
	check_wand_color()

func check_health_color():
	if health_color.r < GameVariables.HEALTH_MINIMAL_VALUE \
	and health_color.g < GameVariables.HEALTH_MINIMAL_VALUE \
	and health_color.b < GameVariables.HEALTH_MINIMAL_VALUE:
		GameVariables.end_game()

func check_wand_color():
	if len(wands) == 0:
		return
	if wand_color.r < GameVariables.WAND_MINIMAL_VALUE \
	and wand_color.g < GameVariables.WAND_MINIMAL_VALUE \
	and wand_color.b < GameVariables.WAND_MINIMAL_VALUE:
		wands.remove_at(current_wand)
		_next_wand()

func check_cape_color():
	if len(capes) == 0:
		return
	if cape_color.r < GameVariables.CAPE_MINIMAL_VALUE \
	and cape_color.g < GameVariables.CAPE_MINIMAL_VALUE \
	and cape_color.b < GameVariables.CAPE_MINIMAL_VALUE:
		capes.remove_at(current_cape)
		_next_cape()

func heal(color: Color):
	health_color = GameVariables.fixColor(health_color + color)

func add_cape(color: Color) -> void:
	cape_changed = true
	capes.append(color)

func add_wand(color: Color) -> void:
	wand_changed = true
	wands.append(color)

func _next_cape():
	cape_changed = true
	if len(capes) > 0:
		current_cape = (current_cape + 1) % len(capes)

func _previous_cape():
	cape_changed = true
	if len(capes) > 0:
		current_cape = (current_cape - 1) % len(capes)

func _next_wand():
	wand_changed = true
	if len(wands) > 0:
		current_wand = (current_wand + 1) % len(wands)

func _previous_wand():
	wand_changed = true
	if len(wands) > 0:
		current_wand = (current_wand - 1) % len(wands)

func _physics_process(_delta):
	if Input.is_action_just_pressed("next_cape"):
		_next_cape()
	elif Input.is_action_just_pressed("previous_cape"):
		_previous_cape()
	if Input.is_action_just_pressed("next_wand"):
		_next_wand()
	elif Input.is_action_just_pressed("previous_wand"):
		_previous_wand()
