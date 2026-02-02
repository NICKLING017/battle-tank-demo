extends Sprite2D

func _ready() -> void:
	var tw = create_tween()
	tw.tween_interval(1) # 延迟等待1秒
	tw.tween_property(self, "modulate", Color(1,1,1,0), 0.5) # 0.5秒内履带颜色变为透明
	tw.tween_callback(queue_free) # 销毁自身
