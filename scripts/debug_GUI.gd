extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "FPS" + str(Engine.get_frames_per_second()) + "\n" +"Helth" + str(PlayerVariables.health_color) + "\n" + "Cape" + str(PlayerVariables.cape_color) + "\n" + "Wand" + str(PlayerVariables.wand_color) + "\n" 
	
	pass
