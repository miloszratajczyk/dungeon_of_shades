extends Control

@onready var _wands_container := get_node("MW/WandsContainer")
@onready var _capes_container := get_node("MC/CapesContainer")
@onready var _key := get_node("MK/KeysContainer/Key")
@onready var _level_label := get_node("LevelLabel")

var _wand_texture := preload ("res://sprites/drops/wand_drop.png")
var _cape_texture := preload ("res://sprites/drops/cape_drop.png")
var _indicator := preload ("res://sprites/ui/indicator.png")

var time := 0.0

func _physics_process(delta: float) -> void:
	time += delta
	_level_label.text = "Time: " + str(int(time))+ \
	"\nLevel: " + str(GameVariables.current_level) + \
	"/8\nLoot: " + str(GameVariables.loot)+ "/" + str(GameVariables.loot_bound[GameVariables.current_level - 1]) 
	if PlayerVariables.cape_changed:
		_update_capes()
		PlayerVariables.cape_changed = false
	if PlayerVariables.wand_changed:
		_update_wands()
		PlayerVariables.wand_changed = false
	if GameVariables.key_changed:
		_key.visible = GameVariables.has_key
		GameVariables.key_changed = false

func _update_wands():
	for n in _wands_container.get_children():
		_wands_container.remove_child(n)
		n.queue_free()
		
	for i in range(len(PlayerVariables.wands)):
		var instance = TextureRect.new()
		instance.texture = _wand_texture
		instance.modulate = PlayerVariables.wands[i]
		_wands_container.add_child(instance)
		if i == PlayerVariables.current_wand:
			var indicator = TextureRect.new()
			indicator.texture = _indicator
			indicator.modulate = Color.WHITE
			instance.add_child(indicator)
			
			
func _update_capes():
	for n in _capes_container.get_children():
		_capes_container.remove_child(n)
		n.queue_free()
		
	for i in range(len(PlayerVariables.capes)):
		var instance = TextureRect.new()
		instance.texture = _cape_texture
		instance.modulate = PlayerVariables.capes[i]
		_capes_container.add_child(instance)
		
		if i == PlayerVariables.current_cape:
			var indicator = TextureRect.new()
			indicator.texture = _indicator
			indicator.modulate = Color.WHITE
			instance.add_child(indicator)
