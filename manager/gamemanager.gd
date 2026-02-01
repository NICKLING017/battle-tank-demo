extends Node

# --- 信号总线 (Signal Bus) ---
signal enemy_killed(pos: Vector2)  # 敌人阵亡，传递坐标用于生成爆炸特效
signal update_health_ui(health: int)  # 通知 UI 更新血量条
signal player_killed               # 玩家阵亡，触发失败逻辑
signal player_win                  # 达成条件，触发胜利逻辑

var score: int = 0 # 获得分值
var enemy_size: int = 3 # 本关敌人总数

func _ready():
	# 敌人阵亡信号连接
	enemy_killed.connect(on_enemy_killed)

func on_enemy_killed(pos):
	score += 1
	if score == enemy_size:
		player_win.emit()
