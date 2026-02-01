extends Area2D

@export var bullet_speed: float = 100 ## 子弹速度


func _process(delta: float) -> void:
	# transform.x 表示节点当前的本地X轴方向向量，也就是它“朝向的方向”；
	# transform.y 表示节点当前的本地Y轴方向向量，一般垂直于 x，表示“向下”；
	# transform.origin 等价于 global_position，是节点在世界坐标中的位置。
	# 使用 transform.x 可以让对象按照“它当前朝向的方向”移动，而不是固定朝右；
	# 如果节点发生了旋转，它的 transform.x 也会自动变化，非常适合用来做跟随方向移动、发射、追踪等行为。
	position += transform.x * bullet_speed * delta # transform是一个变换信息容器，存放位置、旋转、缩放数据


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		area.reduce_health()
		queue_free()
