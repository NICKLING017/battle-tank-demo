extends Area2D

signal hit # 击中反馈信号

@export var damage: int = 1 # 基础伤害
@export var hit_multiple: bool = false  # 是否具备群体杀伤能力


# 触发对方的get_hurt函数，传递伤害值
func apply_hit(hurt_box: Area2D):
	if hurt_box.has_method("get_hurt"):
		hurt_box.get_hurt(damage)
	set_deferred("monitoring", hit_multiple)


func _on_area_entered(area: Area2D) -> void:
	hit.emit()
	apply_hit(area)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
