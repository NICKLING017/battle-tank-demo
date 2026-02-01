extends Control

@onready var label: Label = $MarginContainer/HBoxContainer/PanelContainer/Label
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/ProgressBar
@onready var timer: Timer = $Timer
@onready var panel_container_3: PanelContainer = $MarginContainer/PanelContainer3
@onready var result: Label = $MarginContainer/PanelContainer3/result


func _ready() -> void:
	Gamemanager.enemy_killed.connect(on_enemy_killed)
	Gamemanager.update_health_ui.connect(on_update_health_ui)
	Gamemanager.player_killed.connect(on_player_killed)
	Gamemanager.player_win.connect(on_player_win)


func on_enemy_killed(pos):
	label.text = "Killed: %s" %str(Gamemanager.score)


func on_update_health_ui(health: int):
	var value = 100 * health / 10 # 转换成百分比数值
	progress_bar.value = value


func on_player_killed():
	timer.start()
	await timer.timeout # 延迟展示结算面板
	result.text = "You Lost"
	panel_container_3.show()


func on_player_win():
	timer.start()
	await timer.timeout # 延迟展示结算面板
	result.text = "You Win"
	panel_container_3.show()
