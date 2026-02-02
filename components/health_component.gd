extends Node

signal died   # 死亡信号
signal health_changed(health_percent:float)  # 血量变化信号

@export var max_health: float = 5   # 最大血量值
@onready var current_health = max_health  # 当前血量值

# 用于计算当前血量所占的百分比
func get_health_percent():
	if current_health <= 0:
		return 0
	return min(current_health / max_health, 1)

# 处理受到伤害的逻辑
func get_damage(damage_value: float):
	current_health = max(current_health - damage_value, 0)
	health_changed.emit(get_health_percent())  #触发血量变化信号
	check_death()

# 用于检测血量是否小于等于0
func check_death():
	if current_health <= 0:
		died.emit() # 触发死亡信号

# 负责血量升级逻辑
func upgrade(value):
	current_health = min(max_health, current_health + value)
	health_changed.emit(get_health_percent())
