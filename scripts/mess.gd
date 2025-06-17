extends Control

@onready var view: TextureRect = get_node("View")
@onready var tutorial_view: TextureRect = get_node("TutorialView")
@onready var label: RichTextLabel = get_node("Label")
@onready var skip_label: RichTextLabel = get_node("SkipLabel")
@onready var blur: ColorRect = get_node("Blur")

func set_mess(view_ix: int, text: String):
	view.texture.region = Rect2(24 * view_ix, 0, 24, 24)
	label.text = text

