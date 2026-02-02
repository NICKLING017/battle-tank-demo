extends Area2D

signal get_damage(damage) # 传递处理后的伤害值

@export var armor: int = 0 # 护甲值

func get_hurt(damage: int):
	var final_damage = max(damage - armor, 0)
	get_damage.emit(final_damage)
