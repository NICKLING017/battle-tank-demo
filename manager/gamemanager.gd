extends Node

# --- 信号总线 (Signal Bus) ---
signal bullet_hit(pos: Vector2) # 子弹击中
signal entity_died(pos: Vector2, groups: Array) # 单位死亡（触发爆炸特效）
signal player_killed # 玩家阵亡，触发失败逻辑
signal player_win # 达成条件，触发胜利逻辑
signal score_update # 得分更新
signal update_health_ui(health: float)  # 更新生命值UI
signal update_score_ui(score: int, total: int) # 更新得分版UI

var score: int = 0 # 获得分值
var total_enemy_size: int = 3 # 本关敌人总数

func _ready():
	score_update.connect(on_score_update)


func set_total_enemy_size(value):
	total_enemy_size = value


func on_enemy_killed(pos):
	score += 1
	if score == total_enemy_size:
		player_win.emit()


func on_score_update():
	score += 1
	update_score_ui.emit(score, total_enemy_size)


func restart():
	score = 0
	get_tree().reload_current_scene() # 重新加载当前场景
