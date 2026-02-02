extends Node2D

@export var trail_scene: PackedScene #履带轨迹场景

@onready var timer: Timer = $Timer


func start():
	if timer.is_stopped():
		timer.start()


func stop():
	if not timer.is_stopped():
		timer.stop()


# 生成履带轨迹
func generate_trail():
	var trail = trail_scene.instantiate()
	trail.global_position = owner.global_position # owner是指当前场景的所有者 例如这个节点被player节点使用
	trail.rotation = owner.rotation
	trail.top_level = true
	add_child(trail)


func _on_timer_timeout() -> void:
	generate_trail()
