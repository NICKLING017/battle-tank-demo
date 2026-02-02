extends Line2D

@export var length = 3
@onready var parent = get_parent() # 获取其父节点引用

func _ready() -> void:
	clear_points()
	top_level = true

func _process(delta: float) -> void:
	add_point(parent.global_position)

	if points.size() > length:
		remove_point(0)
