extends Control

@onready var label: Label = $MarginContainer/HBoxContainer/PanelContainer/Label
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/ProgressBar
@onready var timer: Timer = $Timer
@onready var panel_container_3: PanelContainer = $MarginContainer/PanelContainer3
@onready var result: Label = $MarginContainer/PanelContainer3/VBoxContainer/result
@onready var button: Button = $MarginContainer/PanelContainer3/VBoxContainer/Button


func _ready() -> void:
	Gamemanager.update_score_ui.connect(on_update_score_ui)
	Gamemanager.update_health_ui.connect(on_update_health_ui)
	Gamemanager.player_killed.connect(on_player_killed)
	Gamemanager.player_win.connect(on_player_win)
	button.pressed.connect(Gamemanager.restart)
	on_update_score_ui(Gamemanager.score,Gamemanager.total_enemy_size)
	progress_bar.min_value = 0
	progress_bar.max_value = 100


func on_update_score_ui(score,total):
	label.text = "Killed: %s/%s" %[str(score),str(total)]

func on_update_health_ui(value:float):
	progress_bar.value = clamp(value, 0.0, 1.0) * 100.0


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
