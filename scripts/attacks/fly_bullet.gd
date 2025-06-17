extends CharacterBody2D

var direction: Vector2
var health_color: Color = Color.WHITE

var _is_flying := true;

@onready var view: Sprite2D = $View

func _ready():
	view.modulate = health_color

func _physics_process(_delta):
	# handle movement
	if _is_flying:
		velocity = direction * GameVariables.FLY_BULLET_SPEED
		move_and_slide()
	
	#handle collisions
	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body is Player:
			body.damage(health_color * GameVariables.FLY_BULLET_DAMAGE_FACTOR)
			queue_free()
		else:
			_is_flying = false
