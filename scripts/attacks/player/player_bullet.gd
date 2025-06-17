extends CharacterBody2D
class_name PlayerBullet

var direction: Vector2
var _color: Color

@onready var view: Sprite2D = $View

func _ready():
	_color = PlayerVariables.wand_color
	view.modulate = _color

func _process(_delta):
	# handle rotation
	rotate(velocity.angle())

func _physics_process(_delta):
	# handle movement
	velocity = direction * GameVariables.PLAYER_BULLET_SPEED
	move_and_slide()
	
	#handle collisions
	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body.is_in_group("killable"):
			body.damage(_color * GameVariables.PLAYER_BULLET_DAMAGE_FACTOR)
		queue_free()
