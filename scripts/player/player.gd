extends CharacterBody2D
class_name Player

var _speed_factor := 1.0

@onready var dash := $Dash
@onready var shoot := $Shoot
@onready var view := $View
@onready var background := $Background

func damage(color: Color):
	background.push_color(color)
	PlayerVariables.damage(color)

func is_moving():
	return velocity != Vector2.ZERO

func debuff_speed():
	_speed_factor = GameVariables.PLAYER_SPEED_DEBUFF

func buff_speed():
	_speed_factor = 1.0

func _handle_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dash.is_dashing():
		if _speed_factor != GameVariables.PLAYER_SPEED_DEBUFF:
			velocity = input_direction * GameVariables.PLAYER_DASH_SPEED
	elif shoot.is_shooting():
		velocity = Vector2.ZERO
	else:
		velocity = input_direction * GameVariables.PLAYER_SPEED * _speed_factor

func _physics_process(_delta):
	_handle_input()
	move_and_slide()
