extends Node2D

var _time: float

@onready var cape_view: Sprite2D = $CapeView
@onready var hat_view: Sprite2D = $HatView
@onready var wand_view: Sprite2D = $WandView
@onready var player: Player = get_parent()
@onready var shoot := get_node("../Shoot")
@onready var dash := get_node("../Dash")

func _process(delta):
	_time += delta
	
	# handle flipping
	var x_vel = player.velocity.x
	if x_vel < 0:
		for view in [cape_view, hat_view, wand_view]:
			view.flip_h = true
	elif x_vel > 0:
		for view in [cape_view, hat_view, wand_view]:
			view.flip_h = false
	
	# handle rotation
	if shoot.is_shooting():
		self.rotate(sin(_time * 20) * 0.04)
	elif dash.is_dashing():
		self.rotate(delta * 64 * sign(x_vel))
	else:
		self.rotation = 0
	
	# handle health
	hat_view.modulate = PlayerVariables.health_color
	
	# handle cape
	cape_view.modulate = PlayerVariables.cape_color
	
	# handle wand
	wand_view.modulate = PlayerVariables.wand_color
