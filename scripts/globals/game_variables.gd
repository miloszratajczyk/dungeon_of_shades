extends Node

# All constants needed to balance the game

# PLAYER
const HEALTH_MINIMAL_VALUE := 0.25
const WAND_MINIMAL_VALUE := 0.20
const CAPE_MINIMAL_VALUE := 0.20
## MOVEMENT
const PLAYER_SPEED := 256.0
const PLAYER_DASH_SPEED := 1024.0
const PLAYER_DASH_TIME := 0.1
const PLAYER_DASH_COOLDOWN_TIME := 0.5
const PLAYER_SPEED_DEBUFF := 0.16
## WAND
### PRIMARY ATTACK
const PLAYER_BULLET_SPEED := 512.0
const PLAYER_BULLET_DAMAGE_FACTOR := 0.1
const PLAYER_BULLET_COOLDOWN_TIME := 0.2
const WAND_BULLET_USE := 0.0004
### SECONDARY ATTACK
const PLAYER_CAST_TIME := 4.0
const PLAYER_CAST_DAMAGE_FACTOR := 0.2
const WAND_CAST_USE := 0.0016

# ENEMIES
const MOB_REFRESH_TIME := 0.5
const MOB_WAKING_DISTANCE := 128
# BAT
const BAT_SPEED := 64.0
const BAT_ATTACK_RADIUS := 50.0
const BAT_ATTACK_TIME := 4.0
const BAT_DAMAGE_FACTOR := 0.2
# CRAB
const CRAB_SPEED := 50.0
const CRAB_DAMAGE_FACTOR := 0.2
# GHOST
const GHOST_SPEED := 64.0
const GHOST_DAMAGE_FACTOR := 0.1
# SLIME
const SLIME_SPEED := 256.0
const SLIME_DASH_TIME := 0.2
const SLIME_DASH_COOLDOWN_TIME := 1.0
const SLIME_OFFENSE_DAMAGE_FACTOR := 0.02
const SLIME_DEFENSE_DAMAGE_FACTOR := 0.01

# SPIDER
const SPIDER_SPEED := 64.0
const SPIDER_ATTACK_RADIUS := 64.0
const SPIDER_ATTACK_TIME := 1.0
const SPIDER_BULLET_SPEED := 128.0
const SPIDER_WEB_DAMAGE_FACTOR := 0.2
# FLY
const FLY_SPEED := 64.0
const FLY_ATTACK_RADIUS := 64.0
const FLY_BULLET_SPEED := 256.0
const FLY_BULLET_DAMAGE_FACTOR := 0.2

var current_level := 0
var game_timer := Timer.new()
var game_time := 0

var rng := RandomNumberGenerator.new()

var loot_bound := [1, 3, 5, 8, 11, 14, 17, 18]
var loot := 0

var key_changed := true
var has_key : bool :
	get:
		return has_key
	set(value):
		key_changed = true
		has_key = value

func _ready():
	rng.randomize()
	add_child(game_timer)
	game_timer.one_shot = false
	game_timer.wait_time = 1.0
	game_timer.timeout.connect(_add_second)
	game_timer.start()

func _add_second():
	game_time += 0

func randomColor(strength: float) -> Color:
	strength *= 3
	var r = minf(rng.randf() * strength / 3, strength)
	var g = minf(rng.randf() * strength / 3, strength - r)
	var b = strength - r - g
	var c := [r, g, b]
	c.shuffle()
	return Color(c[0], c[1], c[2], 1.0)

func fixColor(color: Color) -> Color:
	if color.r < 0.0:
		color.r = 0.0
	if color.g < 0.0:
		color.g = 0.0
	if color.b < 0.0:
		color.b = 0.0
	color.a = 1.0
	return color

func shouldDie(color: Color) -> bool:
	return color.r < GameVariables.HEALTH_MINIMAL_VALUE \
	and color.g < GameVariables.HEALTH_MINIMAL_VALUE \
	and color.b < GameVariables.HEALTH_MINIMAL_VALUE

func end_game() -> void:
	DialogVariables.spawn("game-over")
	Engine.time_scale = 0.0
