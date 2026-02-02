extends Node2D

@export var speed:float = 400  #速度变量
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hit_box_component: Area2D = $HitBoxComponent

func _ready():
	hit_box_component.hit.connect(on_hit)
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "modulate",Color("ff6e00"),0.2)
	tween.tween_property(self, "modulate",Color("ffffff"),0.2)


func _process(delta: float) -> void:
	position += transform.x * speed * delta

func on_hit():
	Gamemanager.bullet_hit.emit(global_position) # 发出子弹击中信号
	queue_free()


# 超出屏幕区域 销毁自身
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
