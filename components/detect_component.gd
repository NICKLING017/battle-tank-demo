extends Area2D

# 获取玩家位置
func get_player_pos():
	if has_overlapping_areas():
		var target = get_overlapping_areas() # 返回相交的 Area2D 的列表
		if not target.is_empty():
			return target[0].global_position # 返回玩家的全局位置
