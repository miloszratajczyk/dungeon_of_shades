extends CharacterBody2D

var direction: Vector2
var health_color: Color = Color.WHITE

@onready var view: Sprite2D = $View

var _attack = preload ("res://scenes/attacks/spider_web.tscn")

func _ready():
	
	view.modulate = health_color

func _process(_delta):
	# handle rotation
	rotate(velocity.angle() * 2)

func _physics_process(_delta):
	# handle movement
	velocity = direction * GameVariables.SPIDER_BULLET_SPEED
	move_and_slide()
	
	#handle collisions
	for i in get_slide_collision_count():
		var instance := _attack.instantiate()
		instance.health_color = health_color
		get_parent().add_child(instance)
		instance.position = position
		queue_free()
